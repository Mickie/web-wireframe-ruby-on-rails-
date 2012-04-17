require 'spec_helper'

describe "people/new" do
  before(:each) do
    assign(:person, stub_model(Person,
      :first_name => "MyString",
      :last_name => "MyString",
      :home_town => "MyString",
      :home_school => "MyString",
      :position => "MyString",
      :social_info => nil,
      :team => nil
    ).as_new_record)
  end

  it "renders new person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => people_path, :method => "post" do
      assert_select "input#person_first_name", :name => "person[first_name]"
      assert_select "input#person_last_name", :name => "person[last_name]"
      assert_select "input#person_home_town", :name => "person[home_town]"
      assert_select "input#person_home_school", :name => "person[home_school]"
      assert_select "input#person_position", :name => "person[position]"
      assert_select "input#person_social_info", :name => "person[social_info]"
      assert_select "input#person_team", :name => "person[team]"
    end
  end
end
