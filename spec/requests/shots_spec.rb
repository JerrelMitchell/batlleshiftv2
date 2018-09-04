require 'rails_helper'

describe "Api::V1::Shots" do
  context "POST /api/v1/games/:id/shots" do
    let(:player_1_board)   { Board.new(4) }
    let(:player_2_board)   { Board.new(4) }
    let(:sm_ship)          { Ship.new(2) }
    let(:game)             { create(:game, player_1_board: player_1_board, player_2_board: player_2_board) }

    it "updates the message and board with a hit" do
      ShipPlacer.new(board: player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      user = create(:user)
      headers = { "CONTENT_TYPE" => "application/json", "X-API-Key" => user.auth_token }
      game.user_games.create!(user_id: user.id, player_type: 0)
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Hit."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]


      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end

    it "updates board with a miss" do
      user = create(:user)
      headers = { "CONTENT_TYPE" => "application/json", "X-API-Key" => user.auth_token }
      game.user_games.create!(user_id: user.id, player_type: 0)
      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "Your shot resulted in a Miss."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]


      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Miss")
    end

    it "updates the message but not the board with invalid coordinates" do
      player_1_board = Board.new(1)
      player_2_board = Board.new(1)
      user = create(:user)
      game = create(:game, player_1_board: player_1_board, player_2_board: player_2_board)
      game.user_games.create!(user_id: user.id, player_type: 0)

      headers = { "CONTENT_TYPE" => "application/json", "X-API-Key" => user.auth_token }
      json_payload = {target: "B1"}.to_json
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers

      game = JSON.parse(response.body, symbolize_names: true)
      expect(game[:message]).to eq "Invalid coordinates"
    end

    it "updates the message when fired on same spot" do
      game = Game.create(player_1_board: Board.new(4), player_2_board: Board.new(4))
      user = User.create(username: 'bill', email: "bill@bob.bob",
        password: 'bill', status: 1)
      user2 = User.create(username: 'bob', email: "bob@bob.bob",
        password: 'bob', status: 1)
      params1 = {    game_id: game.id,
                     ship_length: 3,
                     start_space: "A1",
                     end_space: "A3"}.to_json
      params2 = {    game_id: game.id,
                     ship_length: 2,
                     start_space: "B1",
                     end_space: "B2"}.to_json
      params3 = {    game_id: game.id,
                     ship_length: 3,
                     start_space: "A1",
                     end_space: "A3"}.to_json
      params4 = {    game_id: game.id,
                     ship_length: 2,
                     start_space: "B1",
                     end_space: "B2"}.to_json
      headers1 = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => user.auth_token }
      headers2 = { "CONTENT_TYPE" => "application/json", "HTTP_X_API_KEY" => user2.auth_token }
      game.user_games.create!(user_id: user.id, player_type: 0)
      game.user_games.create!(user_id: user2.id, player_type: 1)

      json_payload = {target: "A1"}.to_json

      post "/api/v1/games/#{game.id}/ships", params: params1, headers: headers1
      post "/api/v1/games/#{game.id}/ships", params: params2, headers: headers1
      post "/api/v1/games/#{game.id}/ships", params: params3, headers: headers2
      post "/api/v1/games/#{game.id}/ships", params: params4, headers: headers2
      
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers1
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers2
      post "/api/v1/games/#{game.id}/shots", params: json_payload, headers: headers1


      expect(response).to be_success

      game = JSON.parse(response.body, symbolize_names: true)

      expected_messages = "You've already fired on this spot. Get yourself together captain."
      player_2_targeted_space = game[:player_2_board][:rows].first[:data].first[:status]


      expect(game[:message]).to eq expected_messages
      expect(player_2_targeted_space).to eq("Hit")
    end
  end
end
