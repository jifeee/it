require 'spec_helper'

describe Shipment do
  it { should have_many(:milestones) }
  
  it "should be valid" do
    FactoryGirl.build(:shipment).should be_valid
  end
  
  it "should check milestones for damages" do
    FactoryGirl.create(:shipment).should_not be_damaged
    FactoryGirl.create(:shipment, :milestones => [FactoryGirl.build(:damaged)]).should be_damaged
  end
  
  it "should check cargo for validity" do
    FactoryGirl.build(:shipment).should be_valid
    FactoryGirl.build(:shipment, :hawb => "74781140741").should_not be_valid
  end
end
