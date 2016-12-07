class Subscription < ActiveRecord::Base
  belongs_to :payment
  belongs_to :user
  belongs_to :membership
  
  validates_presence_of :user_id, :membership_id, :payment_id
end
