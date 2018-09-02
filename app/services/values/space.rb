class Space
  attr_reader :coordinates, :status, :contents

  def initialize(coordinates)
    @coordinates       = coordinates
    @contents          = nil
    @message_generator = MessageGenerator
    @status            = @message_generator.not_attacked
  end

  def attack!
    @status = if contents && not_attacked?
                contents.attack!
                if contents.is_sunk?
                  message_generator.sink_ship
                else
                  message_generator.hit
                end
              else
                message_generator.miss
              end
  end

  def occupy!(ship)
    @contents = ship
  end

  def occupied?
    !!contents
  end

  def not_attacked?
    status == message_generator.not_attacked
  end

  private

  attr_reader :message_generator
end
