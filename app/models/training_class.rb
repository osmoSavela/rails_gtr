class TrainingClass < ActiveRecord::Base
	has_many :training_sessions, dependent: :destroy
	has_one :deluxe_package

	scope :active, -> { where("active = ?", true)}

  validates_presence_of :name, :description, :price
end
