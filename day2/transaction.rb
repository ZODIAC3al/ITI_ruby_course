class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end

  def to_s
    "User #{user.name} transaction with value #{value}"
  end
end
