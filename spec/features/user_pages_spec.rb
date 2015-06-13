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

      feature "after submission" do
        before { click_button submit }

        scenario { should have_title('Sign up') }
        scenario { should have_content('error') }
        scenario { should have_content("Password can't be blank") }
        scenario { should have_content("Password is too short (minimum is 6 characters)") }
        scenario { should have_content("Name can't be blank") }
        scenario { should have_content("Email can't be blank") }
        scenario { should have_content("Email is invalid") }
        scenario { should have_content("Password confirmation can't be blank") }
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

      feature "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        scenario { should have_title(user.name) }
        scenario { should have_selector('div.alert.alert-success', text: 'Welcome') }

        scenario { should have_link('Sign out') }
      end

      feature "followed by signout" do
        before do
          click_button submit
          click_link "Sign out"
        end
        scenario { should have_link('Sign in') }
      end
    end
  end
end