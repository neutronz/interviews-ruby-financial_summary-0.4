class FinancialSummary
  TRANSACTION_TYPES = %i[deposit refund withdraw]

  attr_accessor :user
  attr_accessor :currency

  def self.one_day(user:, currency:)
    new(user, currency, :one_day)
  end

  def self.seven_days(user:, currency:)
    new(user, currency, :seven_days)
  end

  def self.lifetime(user:, currency:)
    new(user, currency, :lifetime)
  end

  def initialize(user, currency, time_frame = nil)
    @user, @currency = user, currency.to_s.upcase

    @time_frame = case time_frame
                  when :one_day
                    (Time.now.midnight..Time.now)
                  when :seven_days
                    (Time.now.midnight - 7.days)..Time.now
                  when :lifetime
                    nil
                  else
                    raise NotImplementedError
                  end
  end

  def count(category)
    category = category.to_sym
    return unless TRANSACTION_TYPES.include?(category)

    relation = if @time_frame
                 user.transactions.where(category: category, amount_currency: @currency, created_at: @time_frame)
               else
                 user.transactions.where(category: category, amount_currency: @currency)
               end

    relation.count
  end

  def amount(category)
    category = category.to_sym
    return unless TRANSACTION_TYPES.include?(category)

    relation = if @time_frame
                 user.transactions.where(category: category, amount_currency: @currency, created_at: @time_frame)
               else
                 user.transactions.where(category: category, amount_currency: @currency)
               end

    Money.new(relation.pluck(:amount_cents).reduce(:+), @currency.to_s)
  end
end
