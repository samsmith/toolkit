require 'spec_helper'

describe UserLocation do
  describe "newly created" do
    subject { FactoryGirl.create(:user_location) }

    it "must have a user" do
      subject.user.should be_valid
    end

    it "must have a category" do
      subject.category.should be_valid
      subject.category.name.should be_a(String)
    end

    it "should have a geojson string" do
      subject.loc_json.should be_a(String)
      subject.loc_json.should eql(RGeo::GeoJSON.encode(subject.location).to_json)
    end
  end

  describe "to be valid" do
    subject { FactoryGirl.build(:user_location) }

    it "must have a user" do
      subject.user = nil
      subject.should_not be_valid
    end

    it "must have a category" do
      subject.category = nil
      subject.should_not be_valid
    end

    it "must have a location" do
      subject.location = nil
      subject.should_not be_valid
    end

    it "must return an empty geojson string when no location" do
      subject.location = nil
      subject.loc_json.should be_a(String)
      subject.loc_json.should eq("")
    end

    it "should accept a valid geojson string" do
      subject.location = nil
      subject.should_not be_valid
      subject.loc_json = '{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0.14,52.27]}}'
      subject.should be_valid
      subject.location.x.should eql(0.14)
      subject.location.y.should eql(52.27)
    end

    it "should ignore a bogus geojson string" do
      subject.loc_json = 'Garbage'
      subject.should be_valid
    end
  end
end
