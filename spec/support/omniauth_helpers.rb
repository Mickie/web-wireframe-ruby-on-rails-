module OmniAuthHelpers
  def twitter_auth
    OmniAuth.config.mock_auth[:twitter] = { uid: '12345', 
                                            info: 
                                            { 
                                              nickname: "jimbob",
                                              name: "Jim Bob",
                                              image: "image url",
                                              description: "he is a cool dude",
                                              location: "Sequim, WA"
                                            }, 
                                            credentials: { token: "a token", secret: "a secret"} 
                                          }
    return OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:twitter])
  end
  
  def instagram_auth
    OmniAuth.config.mock_auth[:instagram] = { uid: '54321', 
                                              info: 
                                                { 
                                                  nickname: "jimbob", 
                                                  name: "Jim Bob",
                                                  image: "image url",
                                                  bio: "jim is a cool dude" 
                                                }, 
                                              credentials: { token: "inst_token" } 
                                            }
    return OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:instagram])    
  end
  
  def facebook_auth
    OmniAuth.config.mock_auth[:facebook] = { uid: '54321', 
                                            info: 
                                              { 
                                                email: "facebook_init@fanzo.me",
                                                first_name: "first",
                                                last_name: "last",
                                                image: "image url",
                                                location: "Spokane, WA" 
                                              }, 
                                            credentials: { token: "facebook_token" } 
                                            }
    return OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:facebook])
  end

  def foursquare_auth
    OmniAuth.config.mock_auth[:foursquare] = {  uid: '54321', 
                                                info: 
                                                { 
                                                  email: "foursquare_init@fanzo.me",
                                                  first_name: "first",
                                                  last_name: "last",
                                                  image: "image url",
                                                  location: "Kirland, WA"
                                                }, 
                                                credentials: { token: "foursquare_token" } 
                                                }
    return OmniAuth::AuthHash.new(OmniAuth.config.mock_auth[:foursquare])
  end
end
