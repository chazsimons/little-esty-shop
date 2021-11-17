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
    incomplete_invoices = [] if incomplete_invoices == nil
    incomplete_invoices
  end

  def ruby_best_discount
    discounts = item.merchant.bulk_discounts
    applicable_discounts = discounts.where("#{self.quantity} >= bulk_discounts.threshold")
    applicable_discounts.max_by do |discount|
      discount.percentage
    end
  end

  def ruby_discount_revenue
    if ruby_best_discount == nil
      item_revenue
    else
      item_revenue - (item_revenue * ruby_best_discount.percentage)
    end
  end

  # def discount_revenue(invoice_id)
  #   discounted_hash = Merchant.joins(:items, :bulk_discounts)
  #   .joins(invoices: :transactions)
  #   .where(transactions: {result: 0})
  #   .select('bulk_discounts.threshold AS threshold, invoice_items.quantity AS bulk_count')
  #   .where(:bulk_count >= :threshold)
  #   .group('invoice_items.invoice_id')
  #   .sum('(invoice_items.quantity * invoice_items.unit_price) * bulk_discounts.percentage')
  #   discounted_hash[invoice_id].round(2)
  # end
end
