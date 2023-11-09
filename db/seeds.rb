# Seed Categories
categories = ['Food', 'Investment', 'Entertainment', 'Transportation', 'Health', 'Utilities', 'Other']

categories.each do |category_name|
  Category.create(name: category_name)
end

puts 'Categories seeded successfully!'

# Seed Users
User.create(email: 'user1@example.com', password: 'password123')
User.create(email: 'user2@example.com', password: 'password456')

puts 'Users seeded successfully!'

# Seed Transactions
user1 = User.find_by(email: 'user1@example.com')
user2 = User.find_by(email: 'user2@example.com')
categories = Category.all

Transaction.create(user: user1, name: 'Sucorinvest', amount: 1000, category: categories.find_by(name: 'Investment'), description: 'Stocks', transaction_date: Date.today)
Transaction.create(user: user1, name: 'Superindo', amount: -50, category: categories.find_by(name: 'Food'), description: 'Groceries', transaction_date: Date.today)
Transaction.create(user: user2, name: 'Netflix', amount: -30, category: categories.find_by(name: 'Entertainment'), description: 'Movie tickets', transaction_date: Date.today)

puts 'Transactions seeded successfully!'
