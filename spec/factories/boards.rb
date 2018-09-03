FactoryBot.define do
  factory :board do
    piece_count { 2 }
    ships { [] }
    length { 4 }
    board { Board.create_grid }
    sunk_ships { 0 }
  end
end
