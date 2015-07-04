require 'spec_helper'

feature "Micropost pages" do

  subject { page }

  given(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  feature "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    feature "as correct user" do
      before { visit root_path }

      scenario "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end