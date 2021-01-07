require "epayment/engine"

module Epayment
  # set default value
  # @notify_url = ...
  class << self
    attr_accessor :wechat_pay_notify_url, :wechat_payment_model
  end
end
