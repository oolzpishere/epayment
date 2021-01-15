module Epayment
  class Money
    # @params:
    #   fee: integer
    #   digits: integer, indicate how many digits from fee to normal money.
    #     eg. fee = 1, digits = 2, humanize money = 0.01
    attr_reader :fee, :digits, :product
    def initialize(fee, digits: 2)
      @fee = fee
      @digits = digits
      # float
      # eg. 1 / 100.0 = 0.01
      @product = (1 / denominator.to_f)
    end

    def humanize
      (fee.to_i * product).to_s
    end

    private

    # eg. digits = 2, denominator = 100
    def denominator
      sum = 1
      digits.times {|i| sum = (sum * 10) }
      sum
    end
  end
end
