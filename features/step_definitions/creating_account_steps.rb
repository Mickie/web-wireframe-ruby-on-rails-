
When /^I submit valid email and password$/ do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: "secret"
  fill_in "Password confirmation", with: "secret"
  click_button "commit"
  @user = User.find_by_email(@user.email)
end

When /^I click the facebook link$/ do
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({ uid: '54321', info: { email:@user.email }, credentials: { token: "access me" } })
  click_link "facebook-login-button"
  @user = User.find_by_email(@user.email)
end

When /^I click the twitter link$/ do
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new( { uid: '12345', 
                                                                  info: { nickname: "fred" }, 
                                                                  extra: { access_token: { token: "a token", secret: "a secret"} } 
                                                                  })
  click_link "sign-in-with-twitter"
end


Then /^I should see a signout link$/ do
  page.should have_link("Sign out")
end

Then /^I should see Almost There text$/ do
  page.should have_selector('h1', text: "Almost There")
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

Then /^my twitter data should be stored in the DB$/ do
  user = User.find_by_email(@user.email)
  user.should_not be_nil
  user.twitter_username.should == 'fred'
  user.twitter_user_secret.should == 'a secret'
  user.twitter_user_id == '12345'
  user.twitter_user_token == 'a token'
end

Then /^my facebook data should be stored in the DB$/ do
  user = User.find_by_email(@user.email)
  user.facebook_user_id.should == '54321'
  user.facebook_access_token.should == 'access me'
end
