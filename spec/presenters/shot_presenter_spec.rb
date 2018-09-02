require 'rails_helper'

describe ShotPresenter, type: :model do
  before(:each) do
    @game = Game.create(player_1_board: Board.new(4), player_2_board: Board.new(4))
    @user1 = create(:user)
    @user2 = User.create(username: 'bob', email: "bob@bob.bob",
      password: 'bob', status: 1, auth_token: 'bill', activation_token: 'tom')
    @game.user_games.create(user_id: @user1.id, player_type: 'challenger')
    @game.user_games.create(user_id: @user2.id, player_type: 'opponent')
    param_1 = { game_id: @game.id, ship_size: 3, start_space: 'A1', end_space: 'A3' }
    param_2 = { game_id: @game.id, ship_size: 2, start_space: 'B2', end_space: 'B3' }
    param_3 = { game_id: @game.id, ship_size: 3, start_space: 'A1', end_space: 'A3' }
    param_4 = { game_id: @game.id, ship_size: 2, start_space: 'C1', end_space: 'C2' }
    presenter = PlaceShipPresenter.new(param_1, @user1).run
    @game.update(presenter.game_update)
    presenter = PlaceShipPresenter.new(param_2, @user1).run
    @game.update(presenter.game_update)
    presenter = PlaceShipPresenter.new(param_3, @user2).run
    @game.update(presenter.game_update)
    presenter = PlaceShipPresenter.new(param_4, @user2).run
    @game.update(presenter.game_update)
    @turn_processor = TurnProcessor.new(@game, "A1", @user1.player_type)
    @shot_params = {target: 'A1', game_id: @game.id}
    @bad_shot_params = {target: 'X1', game_id: @game.id}
  end

  it 'exists' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    expect(presenter).to be_a(ShotPresenter)
  end

  it 'has attributes' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)

    expect(presenter.game).to eq(@game)
    expect(presenter.user).to eq(@user1)
    expect(presenter.processor).to eq(@turn_processor)
    expect(presenter.status).to eq(nil)
    expect(presenter.message).to eq(nil)
    expect(presenter.target).to eq(@shot_params[:target])
    expect(presenter.winner).to eq(nil)
  end

  it 'tests if unauthorized' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    expect(presenter.unauthorized?).to eq(false)

    presenter = ShotPresenter.new(@shot_params, nil, @turn_processor)
    expect(presenter.unauthorized?).to eq(true)
  end

  it 'tests if game_over' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    expect(presenter.game_over?).to eq(false)

    @game.update(winner: 'bob@bob.bob')
    presenter = ShotPresenter.new(@shot_params, @user2, @turn_processor)

    expect(presenter.game_over?).to eq(true)
  end

  it 'tests if wrong turn' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    expect(presenter.wrong_turn?).to eq(false)

    presenter = ShotPresenter.new(@shot_params, @user2, @turn_processor)
    expect(presenter.wrong_turn?).to eq(true)
  end

  it 'tests if wrong coordinates' do
    presenter = ShotPresenter.new(@bad_shot_params, @user1, @turn_processor)
    expect(presenter.wrong_coordinates?).to eq(true)

    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    expect(presenter.wrong_coordinates?).to eq(false)
  end

  it 'updates if status unauthorized' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    presenter.invalid_unauthorized
    expect(presenter.status).to eq(401)
    expect(presenter.message).to eq("Unauthorized")
  end

  it 'updates if opponents turn' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    presenter.invalid_opponents_turn
    expect(presenter.status).to eq(400)
    expect(presenter.message).to eq("Invalid move. It's your opponent's turn")
  end

  it 'updates if status ok' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    presenter.status_ok
    expect(presenter.status).to eq(200)
    expect(presenter.message).to eq(presenter.processor.message)
  end

  it 'updates if invalid game over' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    presenter.invalid_game_over
    expect(presenter.status).to eq(400)
    expect(presenter.message).to eq("Invalid move. Game over.")
  end

  it 'updates if invalid coordinates' do
    presenter = ShotPresenter.new(@shot_params, @user1, @turn_processor)
    presenter.invalid_coordinates
    expect(presenter.status).to eq(400)
    expect(presenter.message).to eq("Invalid coordinates")
  end

end
