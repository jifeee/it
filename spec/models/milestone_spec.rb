require 'spec_helper'

describe Milestone do
  it { should have_many(:damages) }
  it { should have_one(:signature) }
  it { should belong_to(:shipment) }
  it { should belong_to(:driver) }
  
  it "should be valid" do
    FactoryGirl.build(:milestone).should be_valid
  end
  
  it "should require :shipment_id, :driver_id, :doc, :action on copletion" do
    entity = FactoryGirl.build(:empty_milestone, :completed => true)
    entity.should_not be_valid

    %w(shipment_id driver_id doc action).each do |att|
      entity.errors[att].should include("can't be blank")
    end
  end
  
  it "should not validate fields before completeness" do
    FactoryGirl.build(:empty_milestone).should be_valid
  end
end
