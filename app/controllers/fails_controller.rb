class FailsController < ApplicationController
  def index
    @order = Order.find_by id: params[:order_id]
    @order.destroy if @order.present? && current_user == @order.user
    redirect_to root_url
  end
end
