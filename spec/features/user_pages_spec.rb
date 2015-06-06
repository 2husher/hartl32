require 'spec_helper'

feature "User pages" do

  subject { page }

  feature "signup page" do
    before { visit signup_path }

    scenario { should have_selector('h1',    text: 'Sign up') }
    scenario { should have_title(full_title('Sign up')) }
  end
end