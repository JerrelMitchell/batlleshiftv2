require 'rails_helper'

describe 'post /api/v1/games/game_id/ships' do
  before(:each) do
    @game = Game.create(player_1_board: Board.new(4), player_2_board: Board.new(4))
    @user1 = create(:user)
    @user2 = User.create(username: 'bob', email: "bob@bob.bob",
      password: 'bob', status: 1, auth_token: 'bill', activation_token: 'tom')
    @game.user_games.create(user_id: @user1.id, player_type: 'challenger')
    @game.user_games.create(user_id: @user2.id, player_type: 'opponent')
    @params = {game_id: @game.id, ship_size: 3, start_space: 'A1', end_space: 'A3'}.to_json
    @params2 = {game_id: @game.id, ship_size: 3, start_space: 'A3', end_space: 'A5'}.to_json
    allow_any_instance_of(ApiController).to receive(:current_user).and_return(@user1)
  end

  it 'can place a ship' do
    headers1 = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => @user1.auth_token }

    post "/api/v1/games/#{@game.id}/ships", params: @params, headers: headers1

    content = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success

    expect(content[:id]).to eq(@game.id)
    expect(content[:message]).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
    expect(content[:current_turn]).to eq("challenger")
    expect(content[:player_1_board][:rows].count).to eq(4)
    expect(content[:player_2_board][:rows].count).to eq(4)
    expect(content[:player_1_board][:rows][0][:name]).to eq("row_a")
    expect(content[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
    expect(content[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
    expect(content[:player_1_board][:rows][3][:data][0][:status]).to eq("Not Attacked")
  end
  #
  # it 'gets message if placed in wrong spot' do
  #
  #   post "/api/v1/games/#{@game.id}/ships", params: @params2, headers: headers1
  #
  #   content = JSON.parse(response.body, symbolize_names: true)
  #   expect(response).to be_success
  #
  #   expect(content[:id]).to eq(@game.id)
  #   expect(content[:message]).to eq("Invalid Ship Placement.")
  #   expect(content[:current_turn]).to eq("challenger")
  #   expect(content[:player_1_board][:rows].count).to eq(4)
  #   expect(content[:player_2_board][:rows].count).to eq(4)
  #   expect(content[:player_1_board][:rows][0][:name]).to eq("row_a")
  #   expect(content[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
  #   expect(content[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
  #   expect(content[:player_1_board][:rows][3][:data][0][:status]).to eq("Not Attacked")
  # end
end
