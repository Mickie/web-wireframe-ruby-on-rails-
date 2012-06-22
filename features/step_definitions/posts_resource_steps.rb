Given /^I have created 3 posts$/ do
  3.times do |n|
    FactoryGirl.create(:post, title:"title#{n}", tailgate:@tailgate, user:@tailgate.user)
  end
end  

Then /^there should be (\d+) posts$/ do |aNumber|
  aNumber.to_i.times do |n|
    page.should have_content("title#{n}")
  end
end

Given /^I previously created a post$/ do 
  @tailgate.save
  @tailgate.reload 
  @edit_post.tailgate = @tailgate
  @edit_post.user = @user
  @edit_post.save

  @post.tailgate = @tailgate
  @post.save
end

Then /^I should see the details of the(.*) post$/ do |aType|
  thePrefix = ""
  if (aType.length > 0)
    thePrefix = "#{aType.strip}_"
  end
  thePost = instance_variable_get("@#{thePrefix}post")
  
  page.should have_content(thePost.title)
end

When /^I create a new post$/ do
  page.should have_content("Title")
  fill_in "post_title", with: @new_post.title
  fill_in "post_content", with: @new_post.content
  click_button "add_post"  
end

When /^I edit the post$/ do
  fill_in "Title", with: "Dave's killer post"
  click_button "add_post"  
end

Then /^the changes to the post should be saved$/ do
  @edit_post.reload
  @edit_post.title.should eq("Dave's killer post")
end
