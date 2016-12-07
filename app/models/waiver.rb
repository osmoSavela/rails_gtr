class Waiver < ActiveRecord::Base
  belongs_to :user

  validates_presence_of   :first_name, :last_name, :email, :date_of_birth

end
