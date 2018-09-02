FactoryBot.define do
  factory :game do
    trait :board do
      player_1_board { create :board }
      player_2_board { create :board }
      winner { nil }
      current_turn { "challenger" }
    end
  end
end
