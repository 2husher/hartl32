require 'spec_helper'

feature "Authentication" do

  subject { page }

  feature "signin page" do
    before { visit signin_path }

    scenario { should have_css('h1', text: 'Sign in') }
    scenario { should have_title('Sign in') }
  end

  feature "signin" do
    before { visit signin_path }

    feature "with invalid information" do
      before { click_button "Sign in" }

      scenario { should have_title('Sign in') }
      scenario { should have_css('div.alert.alert-error', text: 'Invalid') }

      feature "after visiting another page" do
        before { click_link "Home" }
        scenario { should_not have_selector('div.alert.alert-error') }
      end
    end

    feature "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      scenario { should have_title(user.name) }
      scenario { should have_link('Profile', href: user_path(user)) }
      scenario { should have_link('Sign out', href: signout_path) }
      scenario { should_not have_link('Sign in', href: signin_path) }
    end
  end
end