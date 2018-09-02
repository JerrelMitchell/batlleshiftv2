require 'rails_helper'

RSpec.describe MessageGenerator, type: :model do
  context '#methods' do
    context 'should return a string with corresponding method call' do
      it 'has a message for #not_attacked' do
        message_generator = MessageGenerator
        expect(message_generator.not_attacked).to eq('Not Attacked')
      end

      it 'has a message for #hit' do
        message_generator = MessageGenerator
        expect(message_generator.hit).to eq('Hit')
      end

      it 'has a message for #miss' do
        message_generator = MessageGenerator
        expect(message_generator.miss).to eq('Miss')
      end

      it 'has a message for #invalid_attack' do
        message_generator = MessageGenerator
        expect(message_generator.invalid_attack).to eq('Invalid attack.')
      end

      it 'has a message for #invalid_coordinates' do
        message_generator = MessageGenerator
        expect(message_generator.invalid_coordinates).to eq('Invalid coordinates')
      end

      it 'has a message for #sink_ship' do
        message_generator = MessageGenerator
        expect(message_generator.sink_ship).to eq('Hit. Battleship sunk.')
      end

      it 'has a message for #game_over_shot' do
        message_generator = MessageGenerator
        expect(message_generator.game_over_shot).to eq('Your shot resulted in a Hit. Battleship sunk. Game over.')
      end

      it 'has a message for #shot_result' do
        message_generator = MessageGenerator
        expect(message_generator.shot_result('Hit')).to eq("Your shot resulted in a Hit.")
      end

      it 'has a message for #place_ship when you have more ships to place' do
        message_generator = MessageGenerator
        ships_to_place = []
        ship1 = Ship.new(3)
        ship2 = Ship.new(2)
        ships_to_place += [ship1, ship2]

        expect(message_generator.place_ship(ship1.length, ships_to_place)).to eq("Successfully placed ship with a size of #{ship1.length}. You have #{ships_to_place.count} ship(s) to place with a size of #{ships_to_place.first.length}.")
      end

      it 'has a message for #place_ship when you have no more ships to place' do
        message_generator = MessageGenerator
        ships_to_place = []
        ship1 = Ship.new(2)

        expect(message_generator.place_ship(ship1.length, ships_to_place)).to eq("Successfully placed ship with a size of #{ship1.length}. You have #{ships_to_place.count} ship(s) to place.")
      end
    end
  end
end
