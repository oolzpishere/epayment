
$(document).on("ready page:load turbolinks:load", function() {

  $('#wechat_pay_form').submit( function(event) {
    event.preventDefault(); //this will prevent the default submit

    alert('submit123')
    wx.config({
      appId: "wx37860e03b3e55945"
    });
    // console.log("under testing")
    params = {
      // TODO: total_fee to hidden field.
      openid: $('#openid').val(),
      total_fee: $('#total_fee').val(),
      out_trade_no: $('#out_trade_no').val(),
      payment_body: $('#payment_body').val()
    }
    wxpay($(this), params);


  });

  function wxpay($wechat_pay_form, params = {}) {
    $.post('/wechat_pay_unifiedorder', params,
    function(data) {
      alert('package' + data.package);

      if (typeof data.package !== 'undefined') {
        invokeWXPay(data)
      } else {
        // TODO: error handling.
      }

      $wechat_pay_form.unbind('submit').submit(); // continue the submit unbind preventDefault
    });
  }


  function invokeWXPay(data) {
    wx.chooseWXPay({
      timestamp: data.timeStamp,
      nonceStr: data.nonceStr,
      package: data.package,
      signType: data.signType,
      paySign: data.paySign,
      success: function (res) {
        alert(JSON.stringify(res));
      },
      error: function(e) {
        alert(JSON.stringify(e));
      }
    });
  }


});
