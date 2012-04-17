require 'spec_helper'

describe GameWatch do
  before do
    mock_geocoding!
    @game_watch = FactoryGirl.build(:game_watch)
  end

  subject { @game_watch }
  
  it { should respond_to(:name) }
  it { should respond_to(:creator) }
  it { should respond_to(:venue) }
  it { should respond_to(:event) } 

end
