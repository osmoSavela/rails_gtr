class MasterReservation < ActiveRecord::Base
  belongs_to :user
  has_many :reservations

  def day
    reservations.first.day.strftime("%m/%d/%y")
  end

  def range_and_lane
    "#{reservations.first.gun_range.name} - Lane #{reservations.first.lane.number}"
  end

  def user_email
		user.try(:email)
	end

	def user_email=(email)
		self.user = User.find_by_last_email(email) if email.present?
	end

  def create_reservations(timeslots, gun_range, lane, date)
    times = Array(timeslots)
    times.each do |time|
      Reservation.create(user_id: self.user_id, gun_range_id: gun_range.id, lane_id: lane.id, day: date, reservation_time: time, master_reservation_id: self.id)
    end

  end

  def self.confirm_checkin(last_name, reservation_id)
    r = Reservation.find(reservation_id)

    if r.user.last_name.downcase == last_name.downcase
      r.master_reservation.checked_in = true
      r.master_reservation.checked_in_at = Time.zone.now
      r.user.perform_reservation_deductions(r)
      r.master_reservation.save
    else
      false
    end
  end

end
