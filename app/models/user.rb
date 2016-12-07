class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

######## RELATIONSHIPS #########################

  has_many :user_training_sessions, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :master_reservations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :waiver, dependent: :destroy
  belongs_to :membership

  ####### validations ###################################

  validates_presence_of :first_name, :last_name, :foid_or_license
  validates_presence_of :address1, :city, :state, :zip, on: :create
  # validates_uniqueness_of :foid_id, on: :create
    
######### scopes ################################
scope :members, -> {where('membership_id is not null')}


#################################################

######### CALLBACKS ##############################
  after_create :send_welcome_email
##################################################



def create_member_reservation(timeslots, gun_type, gun_range, number_of_guests,lane, date, hours_used)  
  mr = MasterReservation.create(user_id: self.id, paid:true, payment_method: "Member Hours", gun_type: gun_type, number_of_guests: number_of_guests.to_i)
  mr.create_reservations(timeslots, gun_range, lane, date)
  UserMailer.reservation_email(mr).deliver
end

def send_welcome_email
  if self.address1.present?
    UserMailer.signup_confirmation(self).deliver
  end
end

  def self.set_foids
    User.all.each do |u|
      u.foid_or_license = u.foid_id
      u.save
    end
  end

######### IMPORT USERS #######################################################


  def self.import(file)
    errors = 0
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      ###MORE LOGIC HERE FOR IMPORT
      user = find_by_foid_id(row["foid_id"]) || new
      user.attributes = row.to_hash.slice(*User.attribute_names())

      # membership = Membership.find_by_name(row["membership"])
      # user.membership_id = membership.tier
      unless user.encrypted_password.present?
       user.password = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(encrypted_password: random_token)
       end
      end

        if user.save
          UserMailer.admin_created_account(user).deliver
        else
          errors = errors + 1
        end

    end

    return errors
  end


  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then CSV.new(file.path,nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type : #{file.original_filename}"
    end
  end
##############################################################


  def self.admin_create_user(first_name, last_name, email)
      user = User.new
      user.password = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(encrypted_password: random_token)
      end

      user.first_name = first_name
      user.last_name = last_name
      user.email = email
      user.save

      return user
  end

  def perform_reservation_deductions(reservation)
    if self.hours_available.present?
      master = reservation.master_reservation
      self.hours_available -= (master.reservations.count/2.00) if self.hours_available && self.hours_available > 0
      self.guests_left -= (master.number_of_guests) if self.guests_left && self.guests_left > 0
      self.save
    end
  end


  def create_stripe_webhook_payment(amount,charge)
    stripe_charge = Stripe::Charge.retrieve(charge)

    unless Payment.exists?(charge_token: charge)
      payment = Payment.create(
        user_id: self.id,
        amount: amount,
        charge_token: charge,
        card_last_4: stripe_charge.source.last4,
        card_brand: stripe_charge.source.brand,
        description: "#{self.membership.name} membership monthly payment."
        )

        self.create_subscription(self.membership, payment)

    end
  end


  def current_card_brand
    if self.payments.present?
      self.payments.last.card_brand
    end
  end

  def current_card_last_4
    if self.payments.present?
      self.payments.last.card_last_4
    end
  end


  def set_annual_membership(membership)
    self.membership_id = membership.id
    self.membership_type = "annual"
    if self.hours_available.present?
      self.hours_available += membership.range_hours
    else
      self.hours_available = membership.range_hours
    end

    if self.guests_left.present?
      self.guests_left += membership.annual_guest_passes
    else
      self.guests_left = membership.annual_guest_passes
    end


    if self.membership_expires_on.present?
      if self.membership_expires_on < Time.zone.now
        self.membership_expires_on = Time.zone.now + 1.year
      else
        self.membership_expires_on = self.membership_expires_on + 1.year
      end
    else
      self.membership_expires_on = Time.zone.now + 1.year
    end
    self.save
  end

  def set_monthly_membership(membership)
    self.membership_id = membership.id
    self.membership_type = "monthly"
    self.hours_available = membership.range_hours
    self.guests_left = membership
    if self.membership_expires_on.present?
      if self.membership_expires_on < Time.zone.now
        self.membership_expires_on = Time.zone.now + 1.year
      else
        self.membership_expires_on = self.membership_expires_on + 1.year
      end
    else
      self.membership_expires_on = Time.zone.now + 1.year
    end
    self.save
  end

  def create_subscription(membership, payment)
    Subscription.create(
      expires_on: self.membership_expires_on,
      user_id: self.id,
      membership_id: membership.id,
      payment_id: payment.id,
      amount_paid: payment.amount/100,
      description: payment.description
      )
  end

   def self.verify_account(last_name, email)
      user = User.find_by('lower(last_name) = ? AND lower(email) = ?', last_name.downcase, email)
      if user.present?
        return user
      else
        return nil
      end
   end

   def outstanding_order_total
      self.order_items.where(order_id: nil).map{|i| i.total_price}.inject(:+)
   end

   def current_order_items
     self.order_items.where(order_id: nil)
   end

   def admin?
   	admin
   end

   def full_name
     "#{self.first_name} #{self.last_name}"
   end


   def reservation_name
     "#{self.first_name} #{self.last_name.first}."
   end
end
