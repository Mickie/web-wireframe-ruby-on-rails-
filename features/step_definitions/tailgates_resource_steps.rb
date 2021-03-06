Given /^I previously created a tailgate$/ do 
  @user.save
  @user.reload 
  @edit_tailgate.user = @user
  @edit_tailgate.save

  @tailgate.user = @user
  @tailgate.save
end

Then /^I should see see the details of the new tailgate$/ do
  page.should have_content(@tailgate.name)
end

When /^I pick a team for my tailgate$/ do
  select @team.name, from: 'tailgate_team_id'
end

When /^I finish creating a new tailgate$/ do
  fill_in "tailgate_name", with: @new_tailgate.name
  fill_in "tailgate_topic_tags", with: @new_tailgate.name
  click_button "submit_fanzone"  
end

Then /^I should see the details of the new tailgate$/ do
  page.should have_content(@new_tailgate.name)
end

When /^I edit the tailgate$/ do
  fill_in "tailgate_description", with: "Dave's killer tailgate" 
  click_button "submit_fanzone"  
end

Then /^the changes to the tailgate should be saved$/ do
  @edit_tailgate.reload
  @edit_tailgate.description.should == "Dave's killer tailgate"
end

Then /^I should be able to associate a team with the tailgate$/ do
  page.should have_selector("#tailgate_team_id")
end

When /^I add a post$/ do
  fill_in "post_content", with: @new_post.content
  click_button "add_post"
end

Then /^I see the new post on the tailgate page$/ do
  page.find("#posts").should have_content(@new_post.content)
end

Given /^I previously added a post$/ do
end

When /^I comment on the post$/ do
  fill_in "comment_content", with: @new_comment.content
  click_button "Add Comment"
end

Then /^I should see the comment on the post on the tailgate page$/ do
  page.find("#posts").should have_content(@new_comment.content)
end




