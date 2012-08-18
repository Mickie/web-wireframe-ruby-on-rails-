require 'spec_helper'

describe InstagramWrapper do
  
  before do
    @instagramWrapper = InstagramWrapper.new(nil)
  end
  
  subject { @instagramWrapper }
  
  describe "mergeTags" do
    let(:theFirstTagArray) { [ Hashie::Mash.new({media_count:100}),  Hashie::Mash.new({media_count:150}) ] }
    
    it "merges smaller value correctly" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 80}), Hashie::Mash.new({media_count: 120}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(100)
      theResult[1].media_count.should eq(80)
      theResult[2].media_count.should eq(150)
      theResult[3].media_count.should eq(120)
    end

    it "merges larger value correctly" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 120}), Hashie::Mash.new({media_count: 180}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(120)
      theResult[1].media_count.should eq(100)
      theResult[2].media_count.should eq(180)
      theResult[3].media_count.should eq(150)
    end

    it "merges mixed values correctly" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 120}), Hashie::Mash.new({media_count: 70}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(120)
      theResult[1].media_count.should eq(100)
      theResult[2].media_count.should eq(150)
      theResult[3].media_count.should eq(70)
    end

    it "handles shorter arrays" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 80}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(100)
      theResult[1].media_count.should eq(80)
      theResult[2].media_count.should eq(150)
    end

    it "handles longer arrays" do
      theSecondTagArray = [ Hashie::Mash.new({media_count: 80}), Hashie::Mash.new({media_count: 120}), Hashie::Mash.new({media_count: 90}) ]
      theResult = subject.mergeTags([ theFirstTagArray, theSecondTagArray])
      theResult[0].media_count.should eq(100)
      theResult[1].media_count.should eq(80)
      theResult[2].media_count.should eq(150)
      theResult[3].media_count.should eq(120)
      theResult[4].media_count.should eq(90)
    end

    describe "with three tags" do
      let( :theSecondTagArray ) { [ Hashie::Mash.new({media_count: 60}) ] }

      it "when smaller" do
        theThirdTagArray = [ Hashie::Mash.new({media_count: 40}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(100)
        theResult[1].media_count.should eq(60)
        theResult[2].media_count.should eq(40)
        theResult[3].media_count.should eq(150)
      end

      it "when larger" do
        theThirdTagArray = [ Hashie::Mash.new({media_count: 80}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(100)
        theResult[1].media_count.should eq(80)
        theResult[2].media_count.should eq(60)
        theResult[3].media_count.should eq(150)
      end

      it "when largest" do
        theThirdTagArray = [ Hashie::Mash.new({media_count: 120}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(120)
        theResult[1].media_count.should eq(100)
        theResult[2].media_count.should eq(60)
        theResult[3].media_count.should eq(150)
      end
    end

    describe "different size arrays" do
      it "should handle long middle array" do
        theSecondTagArray = [ Hashie::Mash.new({media_count: 140}), Hashie::Mash.new({media_count: 60}), Hashie::Mash.new({media_count: 90}) ]
        theThirdTagArray = [ Hashie::Mash.new({media_count: 80}), Hashie::Mash.new({media_count: 160}) ]
        theResult = subject.mergeTags([theFirstTagArray, theSecondTagArray, theThirdTagArray])
        theResult[0].media_count.should eq(140)
        theResult[1].media_count.should eq(100)
        theResult[2].media_count.should eq(80)
        theResult[3].media_count.should eq(160)
        theResult[4].media_count.should eq(150)
        theResult[5].media_count.should eq(60)
        theResult[6].media_count.should eq(90)
      end
    end

  end
  
end
