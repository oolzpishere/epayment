require "epayment/engine"
require "epayment/money"


require 'bootstrap'
require 'jquery-rails'

require 'omniauth'
require "omniauth-wechat-oauth2"

require 'wx_pay'

module Epayment
  # set default value
  # @notify_url = ...
  @test_mode = false

  class << self
    attr_accessor :wechat_pay_notify_url, :wechat_payment_model, :test_mode
  end
end
