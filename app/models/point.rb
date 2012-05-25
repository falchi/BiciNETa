class Point < ActiveRecord::Base
  attr_accessible :latitude,:longitude,:address,:place,:user_id

  belongs_to :user

  geocoded_by :address
  after_validation :geocode
  before_save :checkValidPlace

  validates :place, :presence => true
  validates :address, :presence => true

  def checkValidPlace
    return false if self.latitude.blank? || self.longitude.blank?
  end

end
