class Space
  attr_reader :coordinates, :status, :contents, :fired_on

  def initialize(coordinates)
    @coordinates       = coordinates
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
              elsif !contents && not_attacked?
                message_generator.miss
              else
                @fired_on = true
                @status
              end
  end

  def occupy!(ship)
    @contents = ship
  end

  def occupied?
    contents
  end

  def not_attacked?
    status == message_generator.not_attacked
  end

  private

  attr_reader :message_generator
end
