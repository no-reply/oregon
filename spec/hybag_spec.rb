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
      @image.baggable?.should be_true
    end

    it "should give back a valid bag" do
      @image.write_bag.valid?.should be_true
    end

    it "should write bag to disk" do
      bag = @image.write_bag
      File.directory?(bag.bag_dir).should be_true
    end

    it "should accept subdirectories" do
      bag = @image.write_bag('newBagDir')
      File.directory?(bag.bag_dir).should be_true
      bag.bag_dir.should include('newBagDir')
    end

#    it "should throw an error when item is unsaved" do
#      unsaved = Image.new
#      unsaved.write_bag.should raise_exception 
#    end

  end
end
