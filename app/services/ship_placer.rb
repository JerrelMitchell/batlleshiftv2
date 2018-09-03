class ShipPlacer
  attr_reader :board,
              :ship,
              :start_space,
              :end_space,
              :message

  def initialize(info)
    @board      = info[:board]
    @ship       = info[:ship]
    @start_space = info[:start_space]
    @end_space   = info[:end_space]
  end

  def run
    if same_row?
      place_in_row
    elsif same_column?
      place_in_column
    else
      @message = message_generator.same_row_or_column
    end
  end


  def same_row?
    start_space[0] == end_space[0]
  end

  def same_column?
    start_space[1] == end_space[1]
  end

  def place_in_row
    row = start_space[0]
    range = start_space[1]..end_space[1]
    @message = message_generator.invalid_ship_placement unless range.count == ship.length
    range.each { |column| place_ship(row, column) }
  end

  def place_in_column
    column = start_space[1]
    range  = start_space[0]..end_space[0]
    @message = message_generator.invalid_ship_placement unless range.count == ship.length
    range.each { |row| place_ship(row, column) }
  end

  def place_ship(row, column)
    coordinates = "#{row}#{column}"
    space = board.locate_space(coordinates)
    if space.class != Space
      @message = message_generator.invalid_ship_placement
    elsif space.occupied?
      @message = message_generator.occupied
    else
      space.occupy!(ship)
    end
  end

  private

  def message_generator
    MessageGenerator
  end
end
