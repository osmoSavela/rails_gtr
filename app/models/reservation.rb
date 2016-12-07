class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :lane
  belongs_to :gun_range
  belongs_to :master_reservation
  
  validates_presence_of :user_id, :master_reservation_id, :gun_range_id, :lane_id

  scope :today, -> { where("day = ?", Date.today)}
  scope :for_date, ->(date) { where('date(day) = ?', date.to_date) }



  def coming_up_soon?
    self.reservation_time.between?(Time.zone.now, Time.zone.now + 15.minutes)
  end

  def self.are_made_for_time(lane, gun_range, day, timeslot)
     Reservation.where(lane_id: lane.id, gun_range_id: gun_range.id, day: day.to_date, reservation_time: timeslot ).present?
  end

  def self.find_reservation(lane, gun_range, day, timeslot)
     Reservation.find_by(lane_id: lane.id, gun_range_id: gun_range.id, day: day.to_date, reservation_time: timeslot )
  end

end
