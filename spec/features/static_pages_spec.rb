require 'spec_helper'

feature "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_css('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  feature "Home page" do
    before { visit root_path }

    given(:heading) { "Sample App" }
    given(:page_title) { "" }

    it_should_behave_like "all static pages"
    scenario { should_not have_title('| Home') }

    feature "for signed-in users" do
      given(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        valid_signin user
        visit root_path
      end

      scenario "should render the user's feed" do
        user.feed.each do |item|
          page.should have_css("li##{item.id}", text: item.content)
        end
      end

      feature "should render microposts count with pluralization in sidebar" do
        scenario { should have_css("span", text: "2 microposts") }
      end
    end
  end

  feature "Help page" do
    before { visit help_path }

    given(:heading) { "Help" }
    given(:page_title) { "Help" }

    it_should_behave_like "all static pages"
  end

  feature "About page" do
    before { visit about_path }

    given(:heading) { "About Us" }
    given(:page_title) { "About Us" }

    it_should_behave_like "all static pages"
  end

  feature "Contact page" do
    before { visit contact_path }

    given(:heading) { "Contact" }
    given(:page_title) { "Contact" }

    it_should_behave_like "all static pages"
  end

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