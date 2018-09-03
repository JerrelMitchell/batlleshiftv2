class Shooter
  attr_reader :message

  def initialize(board:, target:)
    @board     = board
    @target    = target
    @message   = ''
  end

  def fire!
    if !valid_shot?
      raise MessageGenerator.invalid_coordinates
    elsif valid_shot?
      space.attack!
      @message = space.status
    end
    self
  end

  def fired_on?
    space.fired_on
  end
  
  def self.fire!(board:, target:)
    new(board: board, target: target).fire!
  end

  private

  attr_reader :board, :target

  def space
    @space ||= board.locate_space(target)
  end

  def valid_shot?
    board.space_names.include?(target)
  end

  def not_attacked?
    space.not_attacked?
  end
end
