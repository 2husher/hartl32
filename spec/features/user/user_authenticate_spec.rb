require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  feature "return value of authenticate method" do
    before { @user.save }
    given(:found_user) { User.find_by_email(@user.email) }

    feature "with valid password" do
      scenario { should == found_user.authenticate(@user.password) }
    end

    feature "with invalid password" do
      given(:user_for_invalid_password) { found_user.authenticate("invalid") }

      scenario { should_not == user_for_invalid_password }
      scenario { user_for_invalid_password.should == false }
    end
  end
end