Before do
  @sport = FactoryGirl.build(:sport)
  @admin.save
end

When /^I create a new sport$/ do
  fill_in "Name",    with: @sport.name
  click_button "commit"
end

Then /^I should be able to edit it$/ do
  page.should have_link('Edit')
end
