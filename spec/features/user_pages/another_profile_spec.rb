require 'spec_helper'

feature "User pages" do

  subject { page }

  feature "another profile page" do
    given(:user) { FactoryGirl.create(:user) }
    given(:another_user) { FactoryGirl.create(:user) }

    given!(:m) { FactoryGirl.create(:micropost, user: another_user, content: "Foo") }

    before do
      valid_signin user
      visit user_path(another_user)
    end

    scenario { should_not have_link('delete', href: micropost_path(m)) }
  end
end
