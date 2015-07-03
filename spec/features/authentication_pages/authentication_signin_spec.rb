require 'spec_helper'

feature "Authentication" do

  subject { page }

  feature "signin" do

    feature "with invalid information" do
      before do
        visit signin_path
        click_button "Sign in"
      end

      scenario { should have_title('Sign in') }
      scenario { should have_error_message('Invalid') }

      feature "after visiting another page" do
        before { click_link "Home" }
        scenario { should_not have_selector('div.alert.alert-error') }
      end
    end

    feature "with valid information" do
      given(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      scenario { should have_title(user.name) }

      scenario { should have_link('Users',    href: users_path) }
      scenario { should have_link('Profile',  href: user_path(user)) }
      scenario { should have_link('Settings', href: edit_user_path(user)) }
      scenario { should have_link('Sign out', href: signout_path) }

      scenario { should_not have_link('Sign in', href: signin_path) }
    end
  end
end