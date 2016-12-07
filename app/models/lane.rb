class Lane < ActiveRecord::Base
  belongs_to :gun_range
  has_many :reservations, dependent: :destroy

  validates_uniqueness_of :number, scope: [:gun_range_id]
  validates_presence_of :number, :gun_range_id

  def number_of_spots_available(date)
    spots = 12
    available = spots - number_of_reservations_for_date(date)
    available
  end

  def number_of_reservations_for_date(date)
    self.reservations.where(day: date).count
  end
end
