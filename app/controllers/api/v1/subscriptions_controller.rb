class Api::V1::SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.new(subscription_params)
    if subscription.save
      render json: SubscriptionSerializer.new(subscription), status: :created
    else
      render json: { errors: { title: 'All fields must be filled in.', status: "400"} }, status: :bad_request
    end
  end

  def update
    subscription = Subscription.find(params[:id])
    if params.key?(:status)
      subscription.update(update_params)
      render json: SubscriptionSerializer.new(subscription), status: :ok
    else
      render json: { errors: {title: 'Cannot update this param.', status: "422"} }, status: :unprocessable_entity
    end
  end


  private

  def update_params
    params.require(:subscription).permit(:status)
  end

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id, :customer_id)
  end
end