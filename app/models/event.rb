class Event < ActiveRecord::Base

  validates_presence_of :event_start_date, :event_end_date, :title, :event_end_time, :event_start_time

  scope :future, -> { where("event_start_date is not null AND event_start_date >= ?", Date.today)}

end
