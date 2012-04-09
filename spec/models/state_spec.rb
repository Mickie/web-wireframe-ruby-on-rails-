require 'spec_helper'

describe State do
  before do
    @state = State.find_by_abbreviation('WA')
  end

  subject { @state }
  
  it { should respond_to(:name) }
  it { should respond_to(:abbreviation) }
end
