class MessageGenerator < StandardError

  def self.not_attacked
    'Not Attacked'
  end

  def self.same_row_or_column
    'Ship must be in either the same row or column.'
  end

  def self.occupied
    'Attempting to place ship in a space that is already occupied.'
  end

  def self.hit
    'Hit'
  end

  def self.miss
    'Miss'
  end

  def self.invalid_ship_placement
    'Invalid ship placement'
  end

  def self.sink_ship
    'Hit. Battleship sunk.'
  end

  def self.invalid_attack
    'Invalid attack.'
  end

  def self.invalid_coordinates
    'Invalid coordinates'
  end

  def self.already_fired_on
    "You've already fired on this spot. Get yourself together captain."
  end

  def self.game_over_shot
    'Your shot resulted in a Hit. Battleship sunk. Game over.'
  end

  def self.shot_result(input)
    "Your shot resulted in a #{input}."
  end

  def self.place_ship(ship_size, ships_to_place)
    if ships_to_place.count.zero?
      "Successfully placed ship with a size of #{ship_size}. "\
      "You have #{ships_to_place.count} ship(s) to place."
    else
      "Successfully placed ship with a size of #{ship_size}. "\
      "You have #{ships_to_place.count} ship(s) to place with a size of #{ships_to_place.first.length}."
    end
  end
end
