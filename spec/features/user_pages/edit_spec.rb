require 'spec_helper'

feature "User pages" do

  subject { page }

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
        fill_in "Confirmation",     with: user.password
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