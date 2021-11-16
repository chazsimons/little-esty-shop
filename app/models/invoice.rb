class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :customer

  enum status: [:cancelled, :completed, 'in progress']

  def successful_transactions
    transactions.success
  end

  def top_selling_by_date
    joins(invoices: :invoice_items)
    .select("invoices.created_at AS date, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue_by_day")
    .group(:date)
    .order(:revenue)
    .first
    .date.strftime('%A, %B %d, %Y')
  end

  def self.ordered_incomplete_invoices
    incomplete_invoices_ids = InvoiceItem.incomplete_invoices
    Invoice.where(id: incomplete_invoices_ids).order(created_at: :asc).pluck(:id, :created_at)
  end

  # def discount_revenue
  #   invoice_items.joins(items: :bulk_discounts)
  #   .joins(:transactions)
  #   .where(transactions: {result: 0})
  #   .select('bulk_discounts.threshold AS threshold, invoice_items.quantity AS bulk_count')
  #   require "pry"; binding.pry
  #   # .group('invoice_items.item_id')
  #   .where(:bulk_count >= :threshold)
  #   .group('merchants.id')
  #   .sum('(invoice_items.quantity * invoice_items.unit_price) * max(bulk_discounts.percentage)')
  #
  # end
end
