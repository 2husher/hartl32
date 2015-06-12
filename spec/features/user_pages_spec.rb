require 'spec_helper'

feature "User pages" do

  subject { page }

  feature "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    scenario { should have_selector('h1',    text: user.name) }
    scenario { should have_title(user.name) }
  end

  feature "signup" do
    before { visit signup_path }

    scenario { should have_selector('h1', text: 'Sign up') }
    scenario { should have_title('Sign up') }

    let(:submit) { "Create my account" }

    feature "with invalid information" do
      scenario "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    feature "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      scenario "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end