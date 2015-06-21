require 'spec_helper'

feature "User pages" do

  subject { page }

  feature "index" do
    before do
      valid_signin FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    scenario { should have_title('All users') }
    scenario { should have_css('h1', text: 'All users') }

    scenario "should list each user" do
      User.all.each do |user|
        page.should have_css('li', text: user.name)
      end
    end
  end

  feature "profile page" do
    given(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    scenario { should have_css('h1',    text: user.name) }
    scenario { should have_title(user.name) }
  end

  feature "signup" do
    before { visit signup_path }

    scenario { should have_css('h1', text: 'Sign up') }
    scenario { should have_title('Sign up') }

    given(:submit) { "Create my account" }

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
        given(:user) { User.find_by(email: 'user@example.com') }

        scenario { should have_title(user.name) }
        scenario { should have_css('div.alert.alert-success', text: 'Welcome') }

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

  feature "edit" do
    given(:user) { FactoryGirl.create(:user) }
    before do
      #visit signin_path
      valid_signin(user)
      visit edit_user_path(user)
    end

    feature "page" do
      scenario { should have_css('h1', text: "Update your profile") }
      scenario { should have_title("Edit user") }
      scenario { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    feature "with invalid information" do
      before { click_button "Save changes" }

      scenario { should have_content('error') }
    end

    describe "with valid information" do
      given(:new_name)  { "New Name" }
      given(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end

      scenario { should have_title(new_name) }
      scenario { should have_css('div.alert.alert-success') }
      scenario { should have_link('Sign out', href: signout_path) }
      scenario { user.reload.name.should  == new_name }
      scenario { user.reload.email.should == new_email }
    end
  end
end