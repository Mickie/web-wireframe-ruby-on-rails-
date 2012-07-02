require 'spec_helper'

describe StaticPagesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'fanzo_team'" do
    it "returns http success" do
      get 'fanzo_team'
      response.should be_success
    end
  end

  describe "GET 'channel'" do
    it "returns http success" do
      get 'channel'
      response.should be_success
    end
  end

end
