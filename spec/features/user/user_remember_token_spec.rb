require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  feature "remember token" do
    before { @user.save }
    scenario{ @user.remember_token.should_not be_blank }
  end
end