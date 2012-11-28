require 'spec_helper'

describe Hybag do

  describe Hybag::Baggable do
    before do 
      image = Image.new
      path = fixture_path  + '/oregondigital_63.nt'
      image.descMetadata.content = File.open(path).read
      image.save
      @image = Image.find(image.pid)
    end

    it "should know it is baggable" do
      @image.baggable.should == true
    end

    it "should give back a valid bag" do
      @image.write_bag.valid?.should == true
    end

  end

end
