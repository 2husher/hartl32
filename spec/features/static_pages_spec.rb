require 'spec_helper'

feature "Static pages" do
  subject { page }

  given(:base_title) { "Ruby on Rails Tutorial Sample App" }

  feature "Home page" do
    before { visit root_path }

    scenario { should have_selector('h1', :text => 'Sample App') }
    scenario { should have_title(full_title("")) }
    scenario { should_not have_title('| Home') }
  end

  feature "Help page" do
    before { visit help_path }

    scenario { should have_css('h1', :text => 'Help') }
    scenario { should have_title(full_title("Help")) }
  end

  feature "About page" do
    before { visit about_path }

    scenario { should have_selector('h1', :text => 'About Us') }
    scenario { should have_title(full_title("About Us")) }
  end

  feature "Contact page" do
    before { visit contact_path }

    scenario { should have_selector('h1', :text => 'Contact') }
    scenario { should have_title(full_title("Contact")) }
  end
end