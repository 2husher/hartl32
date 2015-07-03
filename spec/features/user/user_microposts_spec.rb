require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  feature "micropost associations" do

    before { @user.save }
    given!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    given!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    scenario "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    scenario "should destroy associated microposts" do
      microposts_ids = @user.microposts.map(&:id)
      @user.destroy
      microposts_ids.should_not be_empty
      microposts_ids.each do |micropost_id|
        Micropost.find_by(id:micropost_id).should be_nil
      end
    end

    feature "status" do
      given(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      scenario { @user.feed.should include(newer_micropost) }
      scenario { @user.feed.should include(older_micropost) }
      scenario { @user.feed.should_not include(unfollowed_post) }
    end
  end
end