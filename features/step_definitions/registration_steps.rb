Given /^a user visits the registration page$/ do
  visit new_user_registration_path
end

When /^the user submits valid email and password$/ do
  fill_in "Email",    with: "user@email.com"
  fill_in "Password", with: "secret"
  fill_in "Password confirmation", with: "secret"
  click_button "commit"
end

When /^he clicks the facebook link$/ do
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({ uid: '54321', info: { email:"user@email.com" }, credentials: { token: "access me" } })
  click_link "Sign in with Facebook"
end

When /^he clicks the twitter link$/ do
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new( { uid: '12345', 
                                                                  info: { nickname: "fred" }, 
                                                                  extra: { access_token: { token: "a token", secret: "a secret"} } 
                                                                  })
  click_link "Sign in with Twitter"
end


Then /^he should see his profile page$/ do
  page.should have_selector('title', text: "user@email.com")
end

Then /^he should see a signout link$/ do
  page.should have_link("Sign out")
end

Then /^he should see almost there page$/ do
  page.should have_selector('h1', text: "Almost there")
end

Then /^there should be hidden twitter data$/ do
  page.should have_selector('#user_twitter_user_id')
  page.should have_selector(:xpath, '//input[@value="12345"]')

  page.should have_selector('#user_twitter_user_token')
  page.should have_selector(:xpath, '//input[@value="a token"]')

  page.should have_selector('#user_twitter_user_secret')
  page.should have_selector(:xpath, '//input[@value="a secret"]')

  page.should have_selector('#user_twitter_username')
  page.should have_selector(:xpath, '//input[@value="fred"]')
end

Then /^his twitter data should be stored in the DB$/ do
  user = User.where(email:"user@email.com").first
  user.twitter_username.should == 'fred'
  user.twitter_user_secret.should == 'a secret'
  user.twitter_user_id == '12345'
  user.twitter_user_token == 'a token'
end

Then /^his facebook data should be stored in the DB$/ do
  user = User.where(email:"user@email.com").first
  user.facebook_user_id.should == '54321'
  user.facebook_access_token.should == 'access me'
end
