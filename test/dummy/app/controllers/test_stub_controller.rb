
class TestStubController < ApplicationController
  skip_before_action :verify_authenticity_token

  def set_fake_products
    session["epayment.products"] = [{name: "product_name", single_price: 2, num: 1}]
    render :plain => "", :status => 200
  end

  def set_after_payment_redirection_path
    session["epayment.after_payment_redirection_path"] = "/after_payment_redirection_path"
    render :plain => "", :status => 200
  end


end
