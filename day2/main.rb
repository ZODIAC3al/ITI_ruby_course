require_relative 'user'
require_relative 'transaction'
require_relative 'bank'

# Clean up previous app.log if it exists to ensure a clean run check
File.delete("app.log") if File.exist?("app.log")

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

cba_bank = CBABank.new(users)

cba_bank.process_transactions(transactions) do |status, transaction, reason|
  if status == :success
    puts "Call endpoint for success of #{transaction}"
  else
    puts "Call endpoint for failure of #{transaction} with reason #{reason}"
  end
end
