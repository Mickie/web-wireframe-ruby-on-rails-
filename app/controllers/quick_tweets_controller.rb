class QuickTweetsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index, :show]

  # GET /quick_tweets
  # GET /quick_tweets.json
  def index
    @quick_tweets = []
    
    if params[:sport_id]
      @quick_tweets = QuickTweet.where("sport_id = ?", params[:sport_id])
    else
      @quick_tweets = QuickTweet.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {   
        theHash = buildDataHash(@quick_tweets)      
        render json: theHash 
      }
    end
  end

  # GET /quick_tweets/1
  # GET /quick_tweets/1.json
  def show
    @quick_tweet = QuickTweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quick_tweet }
    end
  end

  # GET /quick_tweets/new
  # GET /quick_tweets/new.json
  def new
    @quick_tweet = QuickTweet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quick_tweet }
    end
  end

  # GET /quick_tweets/1/edit
  def edit
    @quick_tweet = QuickTweet.find(params[:id])
  end

  # POST /quick_tweets
  # POST /quick_tweets.json
  def create
    @quick_tweet = QuickTweet.new(params[:quick_tweet])

    respond_to do |format|
      if @quick_tweet.save
        format.html { redirect_to @quick_tweet, notice: 'Quick tweet was successfully created.' }
        format.json { render json: @quick_tweet, status: :created, location: @quick_tweet }
      else
        format.html { render action: "new" }
        format.json { render json: @quick_tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quick_tweets/1
  # PUT /quick_tweets/1.json
  def update
    @quick_tweet = QuickTweet.find(params[:id])

    respond_to do |format|
      if @quick_tweet.update_attributes(params[:quick_tweet])
        format.html { redirect_to @quick_tweet, notice: 'Quick tweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quick_tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quick_tweets/1
  # DELETE /quick_tweets/1.json
  def destroy
    @quick_tweet = QuickTweet.find(params[:id])
    @quick_tweet.destroy

    respond_to do |format|
      format.html { redirect_to quick_tweets_url }
      format.json { head :no_content }
    end
  end
  
  def buildDataHash( anArrayOfQuickTweets )
    theDataHash = { happy:[], sad:[] }
    
    anArrayOfQuickTweets.each do |aQuickTweet|
      if aQuickTweet.happy
        findOrInsertTweet( aQuickTweet, theDataHash[:happy] )
      else
        findOrInsertTweet( aQuickTweet, theDataHash[:sad] )
      end
    end
    
    return theDataHash
  end
  
  def findOrInsertTweet( aQuickTweet, anArray)
    anArray.each do |aTweetObject|
      if (aTweetObject[:name] == aQuickTweet.name)
        aTweetObject[:tweets].push(aQuickTweet.tweet)
        return
      end
    end
    anArray.push( { name: aQuickTweet.name, 
                    tweets: [ aQuickTweet.tweet ]})
    
  end
end
