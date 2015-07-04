require 'spec_helper'

feature "Static pages" do
  subject { page }

  scenario "should have the right links on the layout" do
    visit root_path
    click_link "About"
    should have_title(full_title('About Us'))
    click_link "Help"
    should have_title(full_title('Help'))
    click_link "Contact"
    should have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    should have_title(full_title('Sign up'))
    click_link "sample app"
    should have_title(full_title(''))
  end
end