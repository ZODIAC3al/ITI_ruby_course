require_relative 'logger'

class Bank
  def process_transactions(transactions, &block)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class CBABank < Bank
  include Logger

  attr_reader :users

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &block)
    transactions_str = transactions.map(&:to_s).join(", ")
    log_info("Processing Transactions #{transactions_str}...")

    transactions.each do |transaction|
      begin
        unless @users.include?(transaction.user)
          raise "#{transaction.user.name} not exist in the bank!!"
        end

        transaction.user.balance += transaction.value

        log_info("#{transaction} succeeded")

        if transaction.user.balance == 0
          log_warning("#{transaction.user.name} has 0 balance")
        end

        block.call(:success, transaction)
      rescue => e
        log_error("#{transaction} failed with message #{e.message}")
        block.call(:failure, transaction, e.message)
      end
    end
  end
end
