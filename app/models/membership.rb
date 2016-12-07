class Membership < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :users

  before_create :create_stripe_plan
  # before_save :update_stripe_plan, if: :name_changed?
  # before_save :delete_stripe_plan, if: :monthly_price_changed?


  def create_stripe_plan
    plan = Stripe::Plan.create(
      :amount => (self.monthly_price*100).to_i,
      :interval => 'month',
      :name => "#{self.name}_#{Date.today.strftime('%m%d%y')}_#{Time.zone.now.strftime('%s')}",
      :currency => 'usd',
      :id => "#{self.id}_#{Time.zone.now.strftime('%s')}"
    )

    self.stripe_plan_id = plan.id
  end

  def update_stripe_plan
    p = Stripe::Plan.retrieve(self.stripe_plan_id)
    p.name = "#{self.name}_#{Date.today.strftime('%m%d%y')}_#{Time.zone.now.strftime('%s')}}"
  end

  def delete_stripe_plan
    p = Stripe::Plan.retrieve(self.stripe_plan_id)
    p.delete

    plan = Stripe::Plan.create(
      :amount => (self.monthly_price*100).to_i,
      :interval => 'month',
      :name => "#{self.name}_#{Date.today.strftime('%m%d%y')}_#{Time.zone.now.strftime('%s')}}",
      :currency => 'usd',
      :id => "#{self.id}_#{Time.zone.now.strftime('%s')}"
    )

    self.stripe_plan_id = plan.id
  end


end
