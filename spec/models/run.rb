# spec/models/run_spec.rb

require 'rails_helper'

# Prefix instance methods with a '#'
describe Run, :type => :model do

  context "create a run and check mandatory informations" do
    it "without started_at" do
      expect(FactoryGirl.build(:run, :started_at => nil)).not_to be_valid
    end

    it "without src_latitude" do
      expect(FactoryGirl.build(:run, :src_latitude => nil)).not_to be_valid
    end

    it "without src_longitude" do
      expect(FactoryGirl.build(:run, :src_longitude => nil)).not_to be_valid
    end

    it "without user" do
      expect(FactoryGirl.build(:run, :src_longitude => nil)).not_to be_valid
    end
  end

  context "validation of mantatory fields" do
    it "with invalid started_at date" do
      expect(FactoryGirl.build(:run, :started_at => 'abc')).not_to be_valid
    end

    it "with valid started_at date" do
      expect(FactoryGirl.build(:run, :started_at => '2012-12-12')).not_to be_valid
    end

    it "with invalid src_latitude" do
      expect(FactoryGirl.build(:run, :src_latitude => 'abc')).not_to be_valid
    end

    it "with valid src_latitude" do
      expect(FactoryGirl.build(:run, :src_latitude => 1.22333)).not_to be_valid
    end

    it "with invalid src_longitude" do
      expect(FactoryGirl.build(:run, :src_longitude => 'abc')).not_to be_valid
    end

    it "with valid src_longitude" do
      expect(FactoryGirl.build(:run, :src_longitude => 1.2)).not_to be_valid
    end
  end

  context "validation of non required fields" do
    it "without name" do
      expect(FactoryGirl.build(:run, :name => nil)).not_to be_valid
    end

    it "without destination name" do
      expect(FactoryGirl.build(:run, :dest_name => nil)).not_to be_valid
    end

    it "without destination latitude" do
      expect(FactoryGirl.build(:run, :dest_latitude => nil)).not_to be_valid
    end

    it "without destination longitude" do
        expect(FactoryGirl.build(:run, :dest_longitude => nil)).not_to be_valid
    end

    it "without total distance" do
      expect(FactoryGirl.build(:run, :total_distance => nil)).not_to be_valid
    end

    it "without maximum speed" do
        expect(FactoryGirl.build(:run, :max_speed => nil)).not_to be_valid
    end

    it "with invalid destination latitude" do
      expect(FactoryGirl.build(:run, :dest_latitude => "abc")).not_to be_valid
    end

    it "with valid destination latitude" do
      expect(FactoryGirl.build(:run, :dest_latitude => 1.2)).not_to be_valid
    end

    it "with invalid destination longitude" do
      expect(FactoryGirl.build(:run, :dest_longitude => 'abc')).not_to be_valid
    end

    it "with valid destination longitude" do
      expect(FactoryGirl.build(:run, :dest_longitude => 1.2)).not_to be_valid
    end

    it "with invalid total distance" do
      expect(FactoryGirl.build(:run, :total_distance => "azerty")).not_to be_valid
    end

    it "with valid total distance" do
      expect(FactoryGirl.build(:run, :total_distance => 1.2)).not_to be_valid
    end

    it "with invalid maximum speed" do
      expect(FactoryGirl.build(:run, :max_speed => "abc")).not_to be_valid
    end

    it "with valid maximum speed" do
      expect(FactoryGirl.build(:run, :max_speed => 12)).not_to be_valid
    end
  end
end
