class Point < ActiveRecord::Base
  attr_accessible :latitude,:longitude,:address,:place

  geocoded_by :address
  after_validation :geocode

  validates :place, :presence => true
  validates :address, :presence => true

end
