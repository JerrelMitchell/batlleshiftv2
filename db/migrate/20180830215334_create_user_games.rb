class CreateUserGames < ActiveRecord::Migration[5.1]
  def change
    create_table :user_games do |t|
      t.references :user, foreign_key: true
      t.references :game, foreign_key: true
      t.integer :player_type, default: 0

      t.timestamps
    end
  end
end
