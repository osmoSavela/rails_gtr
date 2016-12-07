class Payment < ActiveRecord::Base
  attr_accessor :stripe_card_token
  belongs_to :user
  belongs_to :paymentable, polymorphic: true
  has_one :subscription
  # belongs_to :training_session

  after_create :send_payment_email

  def set_paymentable(paymentable)
    self.paymentable_type = paymentable.class.to_s
    self.paymentable_id = paymentable.id
    self.save
  end

  def send_payment_email
    UserMailer.payment_confirmation(self).deliver
  end

  def save_training_payment(training_session)
    if valid?
      if self.user.stripe_customer_token
        customer = Stripe::Customer.retrieve(self.user.stripe_customer_token)
      else
        customer = Stripe::Customer.create(description: "#{self.user.full_name}", card: stripe_card_token)
        self.user.stripe_customer_token = customer.id
        self.user.save
      end
      charge = Stripe::Charge.create(customer: customer.id, currency: 'usd', amount: amount.to_i, description: "#{self.user.full_name}")
      self.charge_token = charge.id
      self.card_last_4 = charge.source.last4
      self.card_brand = charge.source.brand
      self.description = "Session #{training_session.id} - #{training_session.training_class.name}  registration"
      save!
    end

    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating payment: #{e.message}"
      errors.add :base, "There was a problem charging your credit card."
      false
  end

  def save_reservation_payment(times, date, gun_range, lane, gun_type, number_of_guests)
    if valid?
      if self.user.stripe_customer_token
        customer = Stripe::Customer.retrieve(self.user.stripe_customer_token)
      else
        customer = Stripe::Customer.create(description: "#{self.user.full_name}", card: stripe_card_token)
        self.user.stripe_customer_token = customer.id
        self.user.save
      end
      charge = Stripe::Charge.create(customer: customer.id, currency: 'usd', amount: amount.to_i, description: "#{self.user.full_name} lane reservation")
      self.charge_token = charge.id
      self.card_last_4 = charge.source.last4
      self.card_brand = charge.source.brand
      self.description = "#{self.user.full_name}  lane reservation"
      save!

      mr = MasterReservation.create(user_id: self.user.id, paid:true, payment_method: "Credit Card", gun_type: gun_type, number_of_guests: number_of_guests.to_i)
      mr.create_reservations(times, gun_range,lane, date)
      UserMailer.reservation_email(mr).deliver

      self.paymentable_id = mr.id
      self.save
    end

    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating payment: #{e.message}"
      errors.add :base, "There was a problem charging your credit card."
      false
  end

  def save_annual_membership_payment(membership)
    if valid?
      if self.user.stripe_customer_token.present?
        customer = Stripe::Customer.retrieve(self.user.stripe_customer_token)
      else
        customer = Stripe::Customer.create(description: "#{self.user.full_name}", card: stripe_card_token)
        self.user.stripe_customer_token = customer.id
      end

      charge = Stripe::Charge.create(customer: customer.id, currency: 'usd', amount: amount.to_i, description: "#{self.user.full_name}")
      self.charge_token = charge.id
      self.card_last_4 = charge.source.last4
      self.card_brand = charge.source.brand
      self.description = "Annual #{membership.name} Membership payment"
      save!
      self.user.save
    end

    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating payment: #{e.message}"
      errors.add :base, "There was a problem charging your credit card."
      false
  end

  def save_first_monthly_membership_payment(membership)
    if valid?
      if self.user.stripe_customer_token.present?
        customer = Stripe::Customer.retrieve(self.user.stripe_customer_token)
      else
        customer = Stripe::Customer.create(description: "#{self.user.full_name}", card: stripe_card_token)
        self.user.stripe_customer_token = customer.id
      end

      subscription = customer.subscriptions.create(plan: membership.stripe_plan_id, metadata:{cancel_at_period_end: true, current_period_start: Time.zone.now.strftime("%s"), current_period_end: (Time.zone.now + 1.year).strftime("%s")} )
      # self.card_last_4 = customer.sources.data.first.last4
      # self.card_brand = customer.sources.data.first.brand
      # self.description = "Monthly #{membership.name} membership payment"
      # save
    end

    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating payment: #{e.message}"
      errors.add :base, "There was a problem charging your credit card."
      false
  end



  def save_cafe_payment
    if valid?
      charge = Stripe::Charge.create(card: stripe_card_token, currency: 'usd', amount: amount.to_i, description: "#{self.user.full_name}")
      self.charge_token = charge.id
      self.card_last_4 = charge.source.last4
      self.card_brand = charge.source.brand
      self.description = "#{self.user.full_name} cafe order"
      save!
    end

    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating payment: #{e.message}"
      errors.add :base, "There was a problem charging your credit card."
      false
  end


end
