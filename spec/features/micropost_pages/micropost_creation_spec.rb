require 'spec_helper'

feature "Micropost pages" do

  subject { page }

  given(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  feature "micropost creation" do
    before { visit root_path }

    feature "with invalid information" do

      scenario "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      feature "error messages" do
        before { click_button "Post" }
        scenario { should have_content('error') }
      end
    end

    feature "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      scenario "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
end