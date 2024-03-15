require "rails_helper"

describe Subscription, type: :model do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:frequency) }
  it { should validate_presence_of(:customer_id) }
  it { should validate_presence_of(:tea_id) }
  
  it { should belong_to(:tea) }
  it { should belong_to(:customer)}
end