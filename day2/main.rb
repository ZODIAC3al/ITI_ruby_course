require_relative 'user'
require_relative 'transaction'
require_relative 'bank'

# Clean up previous app.log if it exists to ensure a clean run check
File.delete("app.log") if File.exist?("app.log")

# Colors and formatting helpers
def color(text, code)
  "\e[#{code}m#{text}\e[0m"
end

def bold(text)
  "\e[1m#{text}\e[0m"
end

C_GREEN  = 32
C_RED    = 31
C_YELLOW = 33
C_CYAN   = 36
C_BLUE   = 34
C_GRAY   = 90
C_WHITE  = 37

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

# Print Banner
puts "\n" + color("=" * 65, C_CYAN)
puts color(" " * 12 + "🏦  CBA BANKING TRANSACTION SYSTEM - MAIN PANEL  🏦", C_CYAN)
puts color("=" * 65, C_CYAN)

# 1. Print Initial State
puts "\n" + bold("📋 Initial Accounts State:")
puts color("-" * 65, C_GRAY)
users.each do |user|
  puts "   👤 #{user.name.ljust(10)} | Balance: #{color("$#{user.balance}", C_GREEN)}"
end
puts color("-" * 65, C_GRAY)

# Statistics tracking
success_count = 0
failure_count = 0
total_processed_value = 0

puts "\n" + bold("🔄 Processing Transactions...")
puts color("-" * 65, C_GRAY)

cba_bank.process_transactions(transactions) do |status, transaction, reason|
  user = transaction.user
  value = transaction.value
  formatted_val = value < 0 ? "-$#{value.abs}" : "+$#{value}"
  
  if status == :success
    success_count += 1
    total_processed_value += value.abs
    
    val_colored = color(formatted_val, C_RED) # debit is red
    bal_colored = color("$#{user.balance}", C_GREEN)
    
    puts "   #{color("✔ [SUCCESS]", C_GREEN)} User: #{user.name.ljust(8)} | Amt: #{val_colored.ljust(15)} | New Balance: #{bal_colored}"
  else
    failure_count += 1
    
    val_colored = color(formatted_val, C_GRAY)
    reason_colored = color(reason, C_YELLOW)
    
    puts "   #{color("✘ [FAILURE]", C_RED)} User: #{user.name.ljust(8)} | Amt: #{val_colored.ljust(15)} | Reason: #{reason_colored}"
  end
end
puts color("-" * 65, C_GRAY)

# 2. Print Final State
puts "\n" + bold("📋 Final Accounts State:")
puts color("-" * 65, C_GRAY)
users.each do |user|
  bal_colored = user.balance == 0 ? color("$0 (EMPTY)", C_YELLOW) : color("$#{user.balance}", C_GREEN)
  puts "   👤 #{user.name.ljust(10)} | Balance: #{bal_colored}"
end
puts color("-" * 65, C_GRAY)

# 3. Summary Report
puts "\n" + color("=" * 65, C_CYAN)
puts color(" " * 22 + "📊 TRANSACTION RUN SUMMARY 📊", C_CYAN)
puts color("=" * 65, C_CYAN)
total_transactions = transactions.size
success_rate = ((success_count.to_f / total_transactions) * 100).round(1)

puts "   Total Transactions Processed : #{total_transactions}"
puts "   Successful Transactions      : #{color(success_count.to_s, C_GREEN)} (#{success_rate}%)"
puts "   Failed Transactions          : #{color(failure_count.to_s, C_RED)}"
puts "   Total Value Handled          : #{color("$#{total_processed_value}", C_GREEN)}"
puts color("=" * 65, C_CYAN) + "\n"

