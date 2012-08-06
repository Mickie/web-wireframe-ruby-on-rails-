
When /^I edit the brag$/ do
  fill_in "Content",    with: "Jerome Bettis steamroll the Florida Gators"
  click_button "commit"
end

When /^I create a new brag$/ do 
  fill_in "Content",    with: @new_brag.content
  click_button "commit"
end


Then /^the changes to the brag should be saved$/ do
  @edit_brag.reload
  @edit_brag.content.should == "Jerome Bettis steamroll the Florida Gators"
end

Then /^I should see the details of the new brag$/ do
  page.should have_content(@new_brag.content)
end
