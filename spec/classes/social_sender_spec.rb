require 'spec_helper'

describe SocialSender do
  before do
    mock_geocoding!
  end

  describe "sendFollowersUpdate" do
    
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:tailgate1) { FactoryGirl.create(:tailgate) }
    let(:user1tailgate) { FactoryGirl.create(:tailgate, user_id:user1.id) }
    let(:post1) { user1tailgate.posts.create(content:"content1", user_id:user1.id) }
    let(:stubMail) { Object.new }

    before do
      user1.follow!(tailgate1)
      user2.follow!(tailgate1)
      user2.follow!(user1tailgate)
      
      def stubMail.deliver
      end
    end
    
    it "handles nothing new" do
      post1.updated_at = 25.hours.ago
      post1.save
      user1tailgate.posts_updated_at = 25.hours.ago
      user1tailgate.save

      UserMailer.should_receive(:updates_on_followed_fanzones).exactly(0).times
      
      SocialSender.sendFollowersTheirUpdates
    end
    
    it "handles new posts" do
      UserMailer.should_receive(:updates_on_followed_fanzones).once.with(user2, { user1tailgate => { newPosts: [post1], 
                                                                                                     postsWithNewComments: [] } } ).and_return(stubMail)
      
      SocialSender.sendFollowersTheirUpdates
    end
    
    it "handles old posts in different tailgate" do
      post2 = tailgate1.posts.create(content:"content2", user_id: user1.id)
      tailgate1.posts_updated_at = 25.hours.ago
      tailgate1.save

      UserMailer.should_receive(:updates_on_followed_fanzones).once.with(user2, { user1tailgate => { newPosts: [post1], 
                                                                                                     postsWithNewComments: [] } } ).and_return(stubMail)
      
      SocialSender.sendFollowersTheirUpdates
    end

    it "handles old posts in same tailgate" do
      post2 = user1tailgate.posts.create(content:"content2", user_id: user2.id)
      post2.updated_at = 25.hours.ago
      post2.save

      UserMailer.should_receive(:updates_on_followed_fanzones).once.with(user2, { user1tailgate => { newPosts: [post1], 
                                                                                                     postsWithNewComments: [] } } ).and_return(stubMail)
      
      SocialSender.sendFollowersTheirUpdates
    end

    
    it "handles old posts with new comments" do
      post3 = user1tailgate.posts.create(content:"content3", user_id: user2.id)
      comment1 = post3.comments.create(content:"comment1", user_id: user1.id)
      post3.created_at = 25.hours.ago
      post3.save
      
      UserMailer.should_receive(:updates_on_followed_fanzones).once.with(user2, { user1tailgate => { newPosts: [post1], 
                                                                                                     postsWithNewComments: [post3] } } ).and_return(stubMail)
      
      SocialSender.sendFollowersTheirUpdates
    end

    it "handles multiple tailgates with posts" do
      tailgate3 = FactoryGirl.create(:tailgate)
      user3 = FactoryGirl.create(:user)
      user2.follow!(tailgate3)

      post3 = tailgate3.posts.create(content:"content3", user_id: user2.id)
      comment1 = post3.comments.create(content:"comment1", user_id: user1.id)
      post3.created_at = 25.hours.ago
      post3.save
      
      UserMailer.should_receive(:updates_on_followed_fanzones).once.with(user2, { user1tailgate => { newPosts: [post1], postsWithNewComments: [] },
                                                                                   tailgate3 => {newPosts: [], postsWithNewComments: [post3] } } ).and_return(stubMail)
      
      SocialSender.sendFollowersTheirUpdates
    end
    
  end
end