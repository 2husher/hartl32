require 'spec_helper'

feature "User pages" do

  subject { page }

  feature "profile page" do
    given(:user) { FactoryGirl.create(:user) }
    given!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    given!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    scenario { should have_css('h1',    text: user.name) }
    scenario { should have_title(user.name) }

    feature "microposts" do
      scenario { should have_content(m1.content) }
      scenario { should have_content(m2.content) }
      scenario { should have_content(user.microposts.count) }

      feature "pagination" do
        before do
          30.times { |n| FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum_#{n}") }
          visit user_path(user)
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
end