require 'rails_helper'

describe 'POST /api/v1/games' do

  it 'creates a new game' do
    user = create(:user)
    user2 = User.create(username: 'bob', email: "bob@bob.bob",
      password: 'bob', status: 1, auth_token: 'bill', activation_token: 'tom')
    allow_any_instance_of(ApiController).to receive(:current_user).and_return(user)

    post '/api/v1/games?opponent_email=bob@bob.bob'

    content = JSON.parse(response.body, symbolize_names: true)
    expected = Game.last
    expect(response).to be_success

    expect(content[:id]).to eq(expected.id)
    expect(content[:current_turn]).to eq(expected.current_turn)
    expect(content[:player_1_board][:rows].count).to eq(4)
    expect(content[:player_2_board][:rows].count).to eq(4)
    expect(content[:player_1_board][:rows][0][:name]).to eq("row_a")
    expect(content[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
    expect(content[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
    expect(content[:player_1_board][:rows][3][:data][0][:status]).to eq("Not Attacked")
  end
end
