class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications
  
  def self.first_five
    Boat.limit(5)  
  end

  def self.dinghy
    Boat.where("length < ?", 20)
  end

  def self.ship
    Boat.where("length > ?", 20)
  end

  def self.last_three_alphabetically
    Boat.order(name: :desc).limit(3)
  end

  def self.without_a_captain
    Boat.where(captain_id: nil)
  end

  def self.sailboats
    sailboat_id = Classification.find_by_name('Sailboat').id
    boat_ids = BoatClassification.where(classification_id: sailboat_id).pluck(:boat_id)
    Boat.where(id: boat_ids)
  end

  def self.with_three_classifications
    boat_ids = BoatClassification.group(:boat_id).having("count(boat_id) > 2").pluck(:boat_id)
    Boat.where(id: boat_ids)
  end

  def self.longest
    order('length DESC').first
  end
end

