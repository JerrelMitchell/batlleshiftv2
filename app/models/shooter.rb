class Shooter
  def initialize(board:, target:)
    @board     = board
    @target    = target
    @message   = ''
  end

  def fire!
    if !valid_shot?
      raise MessageGenerator.invalid_coordinates
    elsif already_fired? && valid_shot?
      raise MessageGenerator.already_fired
    elsif valid_shot?
      space.attack!
    end
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

  def already_fired?
    !(space.not_attacked?)
  end
end
