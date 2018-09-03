require 'rails_helper'

describe PlaceShipProcessor, type: :model do
  before(:each) do
    @game = Game.create(player_1_board: Board.new(4), player_2_board: Board.new(4))
    @user1 = create(:user)
    @user2 = User.create(username: 'bob', email: "bob@bob.bob",
      password: 'bob', status: 1, auth_token: 'bill', activation_token: 'tom')
    @game.user_games.create(user_id: @user1.id, player_type: 'challenger')
    @game.user_games.create(user_id: @user2.id, player_type: 'opponent')
    @param_info = { game_id: @game.id, ship_size: 3, start_space: 'A1', end_space: 'A3' }
    @param_2 = { game_id: @game.id, ship_size: 2, start_space: 'B2', end_space: 'B3' }
    @param_3 = { game_id: @game.id, ship_size: 3, start_space: 'A1', end_space: 'A3' }
  end

  it 'test it exists' do
    psp = PlaceShipProcessor.new(@param_info, @user1)
    expect(psp).to be_a(PlaceShipProcessor)
  end

  it 'has attributes' do
    psp = PlaceShipProcessor.new(@param_info, @user1)

    expect(psp.game).to eq(@game)
    expect(psp.user).to eq(@user1)
    expect(psp.game_info).to eq(@param_info)
    expect(psp.player_type).to eq(@user1.player_type(@game.id))
    expect(psp.status).to eq(401)
  end

  it 'can tell whos turn is next' do
    psp = PlaceShipProcessor.new(@param_info, @user1)
    expect(psp.next_turn).to eq(0)

    psp = PlaceShipProcessor.new(@param_info, @user2)
    expect(psp.next_turn).to eq(1)
  end

  it 'can get current_board and what player' do
    presenter = PlaceShipPresenter.new(@param_info, @user1).run
    @game.update(presenter.game_update)
    presenter = PlaceShipPresenter.new(@param_2, @user1).run
    @game.update(presenter.game_update)
    psp = PlaceShipProcessor.new(@param_3, @user2)

    expect(psp.current_board.ships.count).to eq(@game.player_2_board.ships.count)
    expect(psp.current_board.ships.count).not_to eq(@game.player_1_board.ships.count)

    expect(psp.player).to eq(2)
  end

  it 'can tell what player is playing' do
    psp = PlaceShipProcessor.new(@param_info, @user1)
    expect(psp.player).to eq(1)

    psp = PlaceShipProcessor.new(@param_info, @user2)
    expect(psp.player).to eq(2)
  end

  it 'can place ship on correct board' do
    psp = PlaceShipProcessor.new(@param_info, @user1)

    expect(psp.place_ship_on_correct_board).to eq(200)
    expect(psp.game.player_1_board.board[0][0]["A1"].contents).to be_a(Ship)
  end
end
