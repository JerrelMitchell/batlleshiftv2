class PlaceShipPresenter
  def initialize(placement_params, current_user)
    @processor = PlaceShipProcessor.new(placement_params, current_user)
  end

  def run
    @processor.place_ship_on_correct_board
    self
  end

  def status
    @status ||= @processor.status
  end

  def message
    @message ||= @processor.message
  end

  def game_update
    @game_update ||= { "player_#{@processor.player}_board" => @processor.current_board, 'current_turn' => @processor.next_turn }
  end
end
