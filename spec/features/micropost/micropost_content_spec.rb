require 'spec_helper'

feature Micropost do

  given(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  feature "with blank content" do
    before { @micropost.content = " " }
    scenario { should_not be_valid }
  end

  feature "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    scenario { should_not be_valid }
  end
end