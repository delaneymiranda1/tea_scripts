class Subscription < ApplicationRecord
  belongs_to :tea
  belongs_to :customer

  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :status
  validates_presence_of :frequency
  validates_presence_of :customer_id
  validates_presence_of :tea_id

  enum status: {"cancelled": 0, "active": 1}
end