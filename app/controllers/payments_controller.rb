class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @form_info = Newebpay::Mpg.new(params).form_info
  end
  
  def notify
    @response = Newebpay::MpgResponse.new(params[:TradeInfo])

    if @response.success?

      @order = Order.find_by(tracking_number: params[:id]) #這裡的value在依訂單修改
      @order.payment_status = "Paid!" 
      @order.save

      redirect_to hello_path(@order.id), notice: "交易完成"
    else
      @user = User.find(1)  #強制登入，後方參數依照訂單更改
      sign_in @user  #勿動
      redirect_to checkout_path, notice: "交易失敗"
    end
  end

  def hello
    @order = Order.find(params[:id])  
    @user = User.find(1)  #強制登入，後方參數依照訂單更改
    sign_in @user   #勿動
  end
end