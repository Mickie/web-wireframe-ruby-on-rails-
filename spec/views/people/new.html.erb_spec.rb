require 'spec_helper'

describe "people/new" do
  before(:each) do
    theStub = stub_model(Person,
      :first_name => "MyString",
      :last_name => "MyString",
      :home_town => "MyString",
      :home_school => "MyString",
      :position => "MyString",
      :social_info => nil,
      :team => nil
    ).as_new_record
    
    theStub.build_social_info
    assign(:person, theStub)
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
      assert_select "select#person_team_id", :name => "person[team_id]"
      assert_select "select#person_type", :name => "person[type]" do
        assert_select "option[value='Athlete']"
        assert_select "option[value='Coach']"
        assert_select "option[value='Superfan']"
        assert_select "option[value='Journalist']"
      end
      
      assert_select "input#person_social_info_attributes_twitter_name", :name => "person[social_info_attributes][twitter_name]"
      assert_select "input#person_social_info_attributes_facebook_page_url", :name => "person[social_info_attributes][facebook_page_url]"
      assert_select "input#person_social_info_attributes_web_url", :name => "person[social_info_attributes][web_url]"
      
    end
  end
end
