require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  feature "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    scenario { should_not be_valid }
  end

  feature "when password doesn't match confirmation" do
    before { @user.password_confirmation = "not_match" }
    scenario { should_not be_valid }
  end

  feature "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    scenario { should_not be_valid }
  end

  feature "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    scenario { should_not be_valid }
  end
end