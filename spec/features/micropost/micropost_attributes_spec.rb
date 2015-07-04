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
end