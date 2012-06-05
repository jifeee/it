require 'spec_helper'

describe Role do
  it { should have_many(:users) }
  it { should have_and_belong_to_many(:permissions) }
  
  it "should be valid" do
    FactoryGirl.build(:role).should be_valid
  end

end
