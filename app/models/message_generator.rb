class MessageGenerator < StandardError

  def initialize(msg = "Invalid attack.")
    super(msg)
  end

  def place_ship(ship_size, ships_to_place)
    unless ships_to_place.count.zero?
      "Successfully placed ship with a size of #{ship_size}. "\
      "You have #{ships_to_place.count} ship(s) to place with a size of #{ships_to_place.first.length}."
    else
      "Successfully placed ship with a size of #{ship_size}. You have #{ships_to_place.count} ship(s) to place."
    end
  end
end
