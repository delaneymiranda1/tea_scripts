require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  before(:each) do
    @customer = Customer.create!(first_name: "Tana", last_name: "Mongeau", email: "tana@cancelled.com", address: "800 Cancelled Ave")
    @tea = Tea.create!(title: "Black Tea", description: "Bitter", temperature: 100, brew_time: "5 minutes")
    @tea2 = Tea.create!(title: "Vanilla Chai", description: "sweet", temperature: 100, brew_time: "5 minutes")
  end

  #POST /api/v1/subscriptions
  it "subscribes a customer to a tea subscription" do
    
    subscription = {
      title: "Black Tea Subscription",
      price: 20,
      status: 1,
      frequency: "monthly",
      tea_id: @tea.id,
      customer_id: @customer.id
    }
    
    headers = { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
    
    post "/api/v1/subscriptions", headers: headers, params: subscription.to_json

    expect(response.status).to eq(201)

    json = JSON.parse(response.body, symbolize_names: true) 
    
    expect(json).to have_key(:data)
    expect(json[:data]).to have_key(:id)
    expect(json[:data]).to have_key(:type)
    expect(json[:data]).to have_key(:attributes)

    expect(json[:data][:attributes]).to have_key(:title)
    expect(json[:data][:attributes]).to have_key(:price)
    expect(json[:data][:attributes]).to have_key(:status)
    expect(json[:data][:attributes]).to have_key(:frequency)
    expect(json[:data][:attributes]).to have_key(:tea_id)
    expect(json[:data][:attributes]).to have_key(:customer_id)
  end

  # sad path subcribing customer
  it "error displays if any missing fields" do
    
    subscription = {
      title: "",
      price: 20,
      status: 1,
      frequency: "monthly",
      tea_id: @tea.id,
      customer_id: @customer.id
    }
    
    headers = { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
    
    post "/api/v1/subscriptions", headers: headers, params: subscription.to_json

    expect(response.status).to eq(400)

    json = JSON.parse(response.body, symbolize_names: true) 
    
    expect(json[:errors][:title]).to eq("All fields must be filled in.")
  end

  #PATCH /api/v1/subscriptions/subscription_id
  it "cancels a subscription" do
    
    subscription = Subscription.create!(title: "Black Tea Subscription", price: 20, status: 1, frequency: "monthly", tea_id: @tea.id, customer_id: @customer.id)

    headers = { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }

    cancelled = { status: 0 }

    patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: cancelled.to_json

    expect(response.status).to eq(200)

    json = JSON.parse(response.body, symbolize_names: true) 

    expect(json).to have_key(:data)
    expect(json[:data]).to have_key(:id)
    expect(json[:data]).to have_key(:type)
    expect(json[:data]).to have_key(:attributes)

    expect(json[:data][:attributes]).to have_key(:title)
    expect(json[:data][:attributes]).to have_key(:price)
    expect(json[:data][:attributes]).to have_key(:status)
    expect(json[:data][:attributes]).to have_key(:frequency)
    
    expect(json[:data][:attributes][:status]).to eq("cancelled")
  end

  # sad path cancelling subscription
  it "does not cancel if subscriber updates wrong param" do
  
    subscription = Subscription.create!(title: "Black Tea Subscription", price: 20, status: 1, frequency: "monthly", tea_id: @tea.id, customer_id: @customer.id)

    headers = { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }

    cancelled = { price: 0 }

    patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: cancelled.to_json

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(422)

    expect(json[:errors]).to have_key(:title)
    expect(json[:errors]).to have_key(:status)
    expect(json[:errors][:title]).to eq("Cannot update this param.")
  end


  #GET /api/v1/subscriptions
  it "shows all the customers subscriptions" do
    subscription = Subscription.create!(title: "Black Tea Subscription", price: 20, status: 0, frequency: "monthly", tea_id: @tea.id, customer_id: @customer.id)
    subscription2 = Subscription.create!(title: "Vanilla Chai Tea Subscription", price: 25, status: 1, frequency: "monthly", tea_id: @tea2.id, customer_id: @customer.id)

    get "/api/v1/subscriptions"

    expect(response.status).to eq(200)

    json = JSON.parse(response.body, symbolize_names: true) 

    expect(json).to have_key(:data)
    expect(json[:data]).to be_a(Array)

    expect(json[:data][0][:attributes][:title]).to eq("Black Tea Subscription")
    expect(json[:data][0][:attributes][:status]).to eq("cancelled")

    expect(json[:data][1][:attributes][:title]).to eq("Vanilla Chai Tea Subscription")
    expect(json[:data][1][:attributes][:status]).to eq("active")
  end
end
