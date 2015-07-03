require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  feature "when name is not present" do
    before { @user.name = " " }
    scenario { should_not be_valid }
  end

  feature "when name is too long" do
    before { @user.name = "a" * 51 }
    scenario { should_not be_valid }
  end
end