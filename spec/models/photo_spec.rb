require 'spec_helper'

describe Photo do
  describe 'to be valid' do
    it 'should have an image' do
      photo = Photo.new(:caption => "test", :image => nil)
      photo.valid?.should == false
      photo.image = File.new("image.jpg","w+")
      photo.valid?.should == true
    end

    it 'should have caption less than 200 characters' do
      photo = Photo.new(:caption => 'a'*250, :image => File.new("image.jpg","w+"))
      photo.valid?.should == false
      photo.caption = 'a'*200
      photo.valid?.should == true
    end
  end
end
