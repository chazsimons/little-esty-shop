# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
BulkDiscount.create!(percentage: 0.5, threshold: 25, merchant_id: 1)
BulkDiscount.create!(percentage: 0.25, threshold: 20, merchant_id: 1)
BulkDiscount.create!(percentage: 0.15, threshold: 10, merchant_id: 1)
BulkDiscount.create!(percentage: 0.5, threshold: 15, merchant_id: 2)
