class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  belongs_to :customer

  enum status: [:cancelled, :completed, 'in progress']

  def successful_transactions
    transactions.success
  end

  def total_revenue
    invoice_items.sum do |ii|
      ii.item_revenue
    end
  end

  def self.ordered_incomplete_invoices
    incomplete_invoices_ids = InvoiceItem.incomplete_invoices
    Invoice.where(id: incomplete_invoices_ids).order(created_at: :asc).pluck(:id, :created_at)
  end

  def ruby_invoice_discount
    invoice_items.sum do |ii|
      ii.ruby_discount_revenue
    end
  end

  # def invoice_discount_revenue
  #   invoice_items.joins([invoice: :transactions], [item: [merchant: :bulk_discounts]])
  #   .where(transactions: {result: 0})
  #   .select('invoices.id, bulk_discounts.threshold AS threshold, invoice_items.quantity AS quantity, bulk_discounts.id')
  #   .group('bulk_discounts.id')
  #   .where(:quantity >= :threshold)
  #   .group('invoices.id')
  #   .sum('(invoice_items.unit_price * quantity) * bulk_discounts.percentage')
  # end
end
