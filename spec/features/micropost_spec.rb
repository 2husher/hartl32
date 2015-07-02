require 'spec_helper'

feature Micropost do

  given(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  scenario { should respond_to(:content) }
  scenario { should respond_to(:user_id) }
  scenario { should respond_to(:user) }
  scenario { @micropost.user.should == user }

  scenario { should be_valid }

  feature "when user_id is not present" do
    before { @micropost.user_id = nil }
    scenario { should_not be_valid }
  end

  feature "with blank content" do
    before { @micropost.content = " " }
    scenario { should_not be_valid }
  end

  feature "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    scenario { should_not be_valid }
  end
end