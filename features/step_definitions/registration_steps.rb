Given /^a user visits the registration page$/ do
  visit new_user_registration_path
end

When /^the user submits valid email and password$/ do
  fill_in "Email",    with: "user@email.com"
  fill_in "Password", with: "secret"
  fill_in "Password confirmation", with: "secret"
  click_button "Sign up"
end

When /^he clicks the facebook link$/ do
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({ uid: '12345', info: { email:"user@email.com" }, credentials: { token: "access me" } })
  click_link "Sign in with Facebook"
end

When /^he clicks the twitter link$/ do
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new( { uid: '12345', 
                                                                  info: { nickname: "foo@bar.com" }, 
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