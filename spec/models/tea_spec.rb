require "rails_helper"

describe Tea, type: :model do
  
  it { should have_many(:subscriptions)}

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:temperature) }
  it { should validate_presence_of(:brew_time) }
end