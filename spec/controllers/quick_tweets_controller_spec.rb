require 'spec_helper'


describe QuickTweetsController do
  
  before do
    @sport = FactoryGirl.create(:sport)
  end
  
  def valid_attributes
    {
      name:"sweet!",
      tweet:"that was sweet",
      sport_id:@sport.id,
      happy:true
    }
  end
  
  describe "GET index" do
    login_user

    before do
      @theFirstQuickTweet = QuickTweet.create! valid_attributes
      @theSecondQuickTweet = QuickTweet.create(name:"bad", tweet:"bad tweet", sport_id:@sport.id, happy:false)

      @theSecondSport = FactoryGirl.create(:sport)
      @theThirdQuickTweet = QuickTweet.create(name:"good", tweet:"good tweet", sport_id:@theSecondSport.id, happy:true)
      @theFourthQuickTweet = QuickTweet.create(name:"bitter", tweet:"bitter tweet", sport_id:@theSecondSport.id, happy:false)
    end
    
    it "assigns all quick_tweets as @quick_tweets" do
      get :index, {}
      assigns(:quick_tweets).should eq([@theFirstQuickTweet, 
                                        @theSecondQuickTweet, 
                                        @theThirdQuickTweet, 
                                        @theFourthQuickTweet])
    end
    
    it "responds to json request with correct format" do

      get :index, format: :json
      theResult = JSON.parse(response.body)
      theResult["happy"].length.should eq(2)
      theResult["sad"].length.should eq(2)

      theResult["happy"][0]["name"].should eq(@theFirstQuickTweet.name)
      theResult["happy"][0]["tweets"][0].should eq(@theFirstQuickTweet.tweet)
      theResult["sad"][0]["name"].should eq(@theSecondQuickTweet.name)
      theResult["sad"][0]["tweets"][0].should eq(@theSecondQuickTweet.tweet)
    end
    
    it "accepts a sport id, and only returns quick tweets for that sport" do
      get :index, sport_id:@theSecondSport.id, format: :json
      theResult = JSON.parse(response.body)
      theResult["happy"].length.should eq(1)
      theResult["sad"].length.should eq(1)

      theResult["happy"][0]["name"].should eq(@theThirdQuickTweet.name)
      theResult["happy"][0]["tweets"][0].should eq(@theThirdQuickTweet.tweet)
      theResult["sad"][0]["name"].should eq(@theFourthQuickTweet.name)
      theResult["sad"][0]["tweets"][0].should eq(@theFourthQuickTweet.tweet)
    end
  end

  describe "GET show" do
    login_user

    it "assigns the requested quick_tweet as @quick_tweet" do
      quick_tweet = QuickTweet.create! valid_attributes
      get :show, {:id => quick_tweet.to_param}
      assigns(:quick_tweet).should eq(quick_tweet)
    end
  end

  describe "GET new" do
    login_admin

    it "assigns a new quick_tweet as @quick_tweet" do
      get :new, {}
      assigns(:quick_tweet).should be_a_new(QuickTweet)
    end
  end

  describe "GET edit" do
    login_admin

    it "assigns the requested quick_tweet as @quick_tweet" do
      quick_tweet = QuickTweet.create! valid_attributes
      get :edit, {:id => quick_tweet.to_param}
      assigns(:quick_tweet).should eq(quick_tweet)
    end
  end

  describe "POST create" do
    login_admin

    describe "with valid params" do
      it "creates a new QuickTweet" do
        expect {
          post :create, {:quick_tweet => valid_attributes}
        }.to change(QuickTweet, :count).by(1)
      end

      it "assigns a newly created quick_tweet as @quick_tweet" do
        post :create, {:quick_tweet => valid_attributes}
        assigns(:quick_tweet).should be_a(QuickTweet)
        assigns(:quick_tweet).should be_persisted
      end

      it "redirects to the created quick_tweet" do
        post :create, {:quick_tweet => valid_attributes}
        response.should redirect_to(QuickTweet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved quick_tweet as @quick_tweet" do
        # Trigger the behavior that occurs when invalid params are submitted
        QuickTweet.any_instance.stub(:save).and_return(false)
        post :create, {:quick_tweet => {}}
        assigns(:quick_tweet).should be_a_new(QuickTweet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        QuickTweet.any_instance.stub(:save).and_return(false)
        post :create, {:quick_tweet => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_admin

    describe "with valid params" do
      it "updates the requested quick_tweet" do
        quick_tweet = QuickTweet.create! valid_attributes
        # Assuming there are no other quick_tweets in the database, this
        # specifies that the QuickTweet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        QuickTweet.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => quick_tweet.to_param, :quick_tweet => {'these' => 'params'}}
      end

      it "assigns the requested quick_tweet as @quick_tweet" do
        quick_tweet = QuickTweet.create! valid_attributes
        put :update, {:id => quick_tweet.to_param, :quick_tweet => valid_attributes}
        assigns(:quick_tweet).should eq(quick_tweet)
      end

      it "redirects to the quick_tweet" do
        quick_tweet = QuickTweet.create! valid_attributes
        put :update, {:id => quick_tweet.to_param, :quick_tweet => valid_attributes}
        response.should redirect_to(quick_tweet)
      end
    end

    describe "with invalid params" do
      it "assigns the quick_tweet as @quick_tweet" do
        quick_tweet = QuickTweet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        QuickTweet.any_instance.stub(:save).and_return(false)
        put :update, {:id => quick_tweet.to_param, :quick_tweet => {}}
        assigns(:quick_tweet).should eq(quick_tweet)
      end

      it "re-renders the 'edit' template" do
        quick_tweet = QuickTweet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        QuickTweet.any_instance.stub(:save).and_return(false)
        put :update, {:id => quick_tweet.to_param, :quick_tweet => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin

    it "destroys the requested quick_tweet" do
      quick_tweet = QuickTweet.create! valid_attributes
      expect {
        delete :destroy, {:id => quick_tweet.to_param}
      }.to change(QuickTweet, :count).by(-1)
    end

    it "redirects to the quick_tweets list" do
      quick_tweet = QuickTweet.create! valid_attributes
      delete :destroy, {:id => quick_tweet.to_param}
      response.should redirect_to(quick_tweets_url)
    end
  end
  
  describe "buildDataHash" do
    before do
      @theFirstQuickTweet = QuickTweet.create! valid_attributes
      @theSecondQuickTweet = QuickTweet.create(name:"bad", tweet:"bad tweet", sport_id:@sport.id, happy:false)
      
      @theArrayOfQuickTweets = [@theFirstQuickTweet, @theSecondQuickTweet]
    end
    
    it "has elements in happy and sad" do
      theResult = subject.buildDataHash( @theArrayOfQuickTweets )
      theResult[:happy].length.should eq(1)
      theResult[:sad].length.should eq(1)
    end
  end
  
  describe "findOrInsertTweet" do
    before do
      @theQuickTweet = QuickTweet.create! valid_attributes
      @theArray = []
    end
    
    it "inserts a new element if not found" do
      subject.findOrInsertTweet( @theQuickTweet, @theArray)
      @theArray.length.should eq(1)
    end
    
    it "adds to an existing element, if found" do
      @theArray.push( { name: @theQuickTweet.name,
                        tweets: [ "tweet1"]
                        })
      subject.findOrInsertTweet( @theQuickTweet, @theArray)
      @theArray[0][:tweets].length.should eq(2)                  
    end
  end

end
