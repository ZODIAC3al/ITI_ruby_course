class User
  attr_reader :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def balance=(new_balance)
    if new_balance < 0
      raise "Not enough balance"
    end
    @balance = new_balance
  end
end
