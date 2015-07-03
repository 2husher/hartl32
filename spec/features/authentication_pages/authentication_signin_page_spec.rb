require 'spec_helper'

feature "Authentication" do

  subject { page }

  feature "signin page" do
    before { visit signin_path }

    scenario { should have_css('h1', text: 'Sign in') }
    scenario { should have_title('Sign in') }
  end
end