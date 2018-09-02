
class PlaceShipPresenter
  attr_reader :game_update,
              :status,
              :message

  def initialize(placement_params, current_user)
    @processor = PlaceShipProcessor.new(placement_params, current_user)
  end

  def run
    @processor.place_ship_on_correct_board
    @game_update = {"player_#{@processor.player}_board" => @processor.current_board,
                "current_turn" => @processor.next_turn}
    @status = @processor.status
    @message = @processor.message
    return self
  end

end
