require 'rails_helper'

describe TurnProcessor, type: :model do
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
    @tp1 = TurnProcessor.new(@game, "A1", @user1.player_type(@game.id))
    @tp2 = TurnProcessor.new(@game, "X1", @user2.player_type(@game.id))
  end

  it 'can check if correct turn' do
    expect(@tp1.correct_turn?).to eq(true)
    expect(@tp2.correct_turn?).to eq(false)
  end

  it 'can check if valid target' do
    expect(@tp1.valid_target).to eq(true)
    expect(@tp2.valid_target).to eq(false)
  end

  it 'can check if game over?' do
    expect(@tp1.game_over?).to eq(false)

    allow_any_instance_of(Board).to receive(:all_sunk?).and_return(true)
    expect(@tp1.game_over?).to eq(true)
  end

  it 'can run attack sequence' do
    allow_any_instance_of(Game).to receive(:opponent!).and_return(true)
    expect(@tp1.run!).to eq(true)

    allow_any_instance_of(Game).to receive(:opponent?).and_return(true)
    allow_any_instance_of(Game).to receive(:challenger?).and_return(false)
    allow_any_instance_of(Game).to receive(:challenger!).and_return(true)

    expect(@tp1.run!).to eq(true)
  end

  it 'can return messages' do
    expect(@tp1.message).to be_a(String)
  end

  it 'can attack_opponent' do
    allow_any_instance_of(Shooter).to receive(:message).and_return('Hit. Battleship sunk.')

    expect(@tp1.attack_opponent).to eq(["Your shot resulted in a Hit. Battleship sunk.."])
  end

  it 'can attack_challenger' do
    allow_any_instance_of(Shooter).to receive(:message).and_return('Hit. Battleship sunk.')

    expect(@tp1.attack_challenger).to eq(["Your shot resulted in a Hit. Battleship sunk.."])
  end

  it 'can generate_message' do
    allow_any_instance_of(Board).to receive(:all_sunk?).and_return(true)

    expect(@tp1.generate_message('blah')).to eq(["Your shot resulted in a Hit. Battleship sunk. Game over."])
  end
end
