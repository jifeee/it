require 'spec_helper'

describe Permission do
  it { should have_and_belong_to_many :roles }
  
  it "should be valid" do
    FactoryGirl.build(:permission).should be_valid
  end
end
