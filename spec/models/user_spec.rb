require 'spec_helper'

describe User do

  it { should belong_to(:role) }
  it { should have_many(:milestones) }

  it "should be valid" do
    FactoryGirl.build(:user).should be_valid
  end

end
