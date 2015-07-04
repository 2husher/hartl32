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

    feature "feed pagination" do
      given(:user) { FactoryGirl.create(:user) }
      before do
        31.times { |n| FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum_#{n}") }
        valid_signin user
        visit root_path
      end

      scenario { should have_css('div.pagination') }

      scenario "should list each micropost" do
        Micropost.paginate(page: 1).each do |micropost|
          page.should have_css('li', text: micropost.content)
        end
      end
    end
  end
end