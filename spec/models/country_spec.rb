require 'spec_helper'

describe Country do
  before do
    @country = FactoryGirl.create(:country)
  end

  subject { @country }
  
  it { should respond_to(:name) }
  it { should respond_to(:abbreviation) }
end
