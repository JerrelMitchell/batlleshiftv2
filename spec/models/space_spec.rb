require 'rails_helper'

describe Space, type: :model do
  before(:each) do
    @space = Space.new('A1')
    @ship = Ship.new(3)
  end

  it 'exists' do
    expect(@space).to be_a(Space)
  end

  it 'has attributes' do
    expect(@space.coordinates).to eq('A1')
    expect(@space.contents).to eq(nil)
    expect(@space.coordinates).to eq('A1')
    expect(@space.coordinates).to eq('A1')
  end

  it 'can attack' do
    expect(@space.attack!).to eq("Miss")

    @space.occupy!(@ship)
    allow_any_instance_of(Space).to receive(:not_attacked?).and_return(true)

    expect(@space.attack!).to eq("Hit")

    allow_any_instance_of(Ship).to receive(:is_sunk?).and_return(true)

    expect(@space.attack!).to eq("Hit. Battleship sunk.")
  end

  it 'can occupy space' do
    expect(@space.occupy!(@ship)).to eq(@ship)

    expect(@space.contents).to eq(@ship)
  end

  it 'can say if its occupied' do
    expect(@space.occupied?).to be_falsey

    @space.occupy!(@ship)
    expect(@space.occupied?).to be_truthy
  end

  it 'can tell if its been attacked' do
    expect(@space.not_attacked?).to be_truthy
    @space.occupy!(@ship)
    @space.attack!

    expect(@space.not_attacked?).to be_falsey
  end
end
