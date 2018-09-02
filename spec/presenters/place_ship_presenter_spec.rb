require 'rails_helper'

describe PlaceShipPresenter, type: :model do
  let(:player_1_board)   { Board.new(4) }
  let(:player_2_board)   { Board.new(4) }
  let(:game)    {
    create(:game,
      player_1_board: player_1_board,
      player_2_board: player_2_board
    )
  }
  let(:param_info) {
    { game_id: game.id, ship_size: 3, start_space: 'A1', end_space: 'A3' }
  }

  before(:each) do
    @user1 = create(:user)
    @user2 = User.create(username: 'bob', email: "bob@bob.bob",
      password: 'bob', status: 1, auth_token: 'bill', activation_token: 'tom')
    game.user_games.create(user_id: @user1.id, player_type: 0)
    game.user_games.create(user_id: @user2.id, player_type: 1)
  end

  it 'exists' do
    psp = PlaceShipPresenter.new(param_info, @user1)
    expect(psp).to be_a(PlaceShipPresenter)
  end

  it 'returns a message' do
    psp = PlaceShipPresenter.new(param_info, @user1).run

    expect(psp.message).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
  end

  it 'returns a status' do
    psp = PlaceShipPresenter.new(param_info, @user1).run

    expect(psp.status).to eq(200)
  end

  it 'returns a game update hash' do
    psp = PlaceShipPresenter.new(param_info, @user1).run

    expect(psp.game_update).to eq({"player_1_board" => psp.processor.current_board,
                "current_turn" => 0})
  end
end
