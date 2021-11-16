class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  enum status: [:packaged, :pending, :shipped]

  def item_revenue
    quantity * unit_price
  end

  def self.item_revenue
    revenue = group(:item_id).sum('quantity * unit_price')
    revenue.sort_by{ |_, v| -v }.to_h.keys
  end

  def self.incomplete_invoices

    incomplete_invoices = InvoiceItem.select('invoice_items.*').where("status = 0 OR status = 1").distinct.order(invoice_id: :asc).pluck(:invoice_id)
    if incomplete_invoices == nil
      incomplete_invoices = []
    end
    incomplete_invoices
  end

  def discount_revenue(invoice_id)
    discounted_hash = Merchant.joins(:items, :bulk_discounts)
    .joins(invoices: :transactions)
    .where(transactions: {result: 0})
    .select('bulk_discounts.threshold AS threshold, invoice_items.quantity AS bulk_count')
    .where(:bulk_count >= :threshold)
    .group('invoice_items.invoice_id')
    .sum('(invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage')
    (discounted_hash[invoice_id].to_f / 100).round(2)
  end

  def invoice_discount_revenue(invoice_id)
    discount_id_hash = InvoiceItem.all
    .joins([invoice: :transactions], [item: [merchant: :bulk_discounts]])
    .where(transactions: {result: 0})
    .select('invoices.id, bulk_discounts.threshold AS threshold, invoice_items.quantity AS quantity, bulk_discounts.id')
    .group('bulk_discounts.id')
    .where(:quantity >= :threshold)
    .group('invoices.id')
    .sum('(invoice_items.unit_price * quantity) * bulk_discounts.percentage')
  end
end
