require "epayment/engine"

require 'bootstrap'
require 'jquery-rails'

require 'omniauth'
require "omniauth-wechat-oauth2"

module Epayment
  # set default value
  # @notify_url = ...
  class << self
    attr_accessor :wechat_pay_notify_url, :wechat_payment_model
  end
end
