require 'spec_helper'

describe "tailgates/index" do
  before(:each) do
    @team = stub_model(Team, id:1, name:"Seahawks")
    assign(:tailgates, [
      stub_model(Tailgate,
        :name => "Name",
        :team => @team
      ),
      stub_model(Tailgate,
        :name => "Name",
        :team => @team
      ),
      stub_model(Tailgate,
        :name => "Name",
        :team => @team
      )
    ])
  end

  it "renders a list of tailgates" do
    render
    view.should render_template(partial:"_fanzone_tile")
  end
end
