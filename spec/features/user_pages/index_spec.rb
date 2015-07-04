require 'spec_helper'

feature "User pages" do

  subject { page }

  feature "index" do

    given(:user) { FactoryGirl.create(:user) }

    before(:each) do
      valid_signin user
      visit users_path
    end

    scenario { should have_title('All users') }
    scenario { should have_css('h1', text: 'All users') }

    feature "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      scenario { should have_css('div.pagination') }

      scenario "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_css('li', text: user.name)
        end
      end
    end

    feature "delete links" do

      scenario { should_not have_link('delete') }

      feature "as an admin user" do
        given(:admin) { FactoryGirl.create(:admin) }
        before do
          valid_signin admin
          visit users_path
        end

        scenario { should have_link('delete', href: user_path(User.first)) }
        scenario "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        scenario { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end