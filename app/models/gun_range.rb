class GunRange < ActiveRecord::Base
  has_many :reservations, dependent: :destroy
  has_many :lanes, dependent: :destroy
end
