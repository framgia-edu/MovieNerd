class FailsController < ApplicationController
  def index
    @order = Order.find_by id: params[:order_id]
    @order.destroy if @order.present? && current_user == @order.user
    redirect_to order, method: :delete
  end
end
