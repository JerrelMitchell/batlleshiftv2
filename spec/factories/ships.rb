FactoryBot.define do
  factory :ship do
    piece_count { 3 }
    damage      { 0 }
    start_space { nil }
    end_space   { nil }
  end
end
