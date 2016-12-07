class DeluxePackage < ActiveRecord::Base
  belongs_to :training_class

  validates_presence_of :price, :value, :training_class_id

end
