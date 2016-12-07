class Announcement < ActiveRecord::Base

  before_save :check_for_active_announcement

  def check_for_active_announcement
    active_announcement =  Announcement.active
    if active_announcement.present?
      if self.active && self != active_announcement
        active_announcement.update(active: false)
      end
    end
  end

  def self.has_one_active?
    self.exists?(active: true)
  end

  def self.active
    self.find_by(active: true)
  end

end
