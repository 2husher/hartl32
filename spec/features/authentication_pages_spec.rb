require 'spec_helper'

feature "Authentication" do

  subject { page }

  feature "signin page" do
    before { visit signin_path }

    scenario { should have_css('h1', text: 'Sign in') }
    scenario { should have_title('Sign in') }
  end

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

  feature "authorization" do

    feature "for non-signed-in users" do
      given(:user) { FactoryGirl.create(:user) }

      feature "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        feature "after signing in" do

          scenario "should render the desired protected page" do
            page.should have_title('Edit user')
          end
        end
      end

      feature "in the Users controller" do

        feature "visiting the edit page" do
          before { visit edit_user_path(user) }
          scenario { should have_title('Sign in') }
        end

        describe "visiting the user index" do
          before { visit users_path }
          scenario { should have_title('Sign in') }
        end
      end

      feature "visiting Home page" do
        before { visit root_path }

        scenario { should_not have_link('Profile',  href: user_path(user)) }
        scenario { should_not have_link('Settings', href: edit_user_path(user)) }
      end
    end

    feature "as wrong user" do
      given(:user) { FactoryGirl.create(:user) }
      given(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

      before { valid_signin user }

      feature "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        scenario { should_not have_title(full_title('Edit user')) }
      end
    end
  end
end
# save_and_open_page