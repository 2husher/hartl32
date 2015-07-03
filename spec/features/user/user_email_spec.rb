require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  feature "when email is not present" do
    before { @user.email = " " }
    scenario { should_not be_valid }
  end

  feature "when email format is invalid" do
    scenario "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  feature "when email format is valid" do
    scenario "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  feature "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    scenario { should_not be_valid }
  end

  feature "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    scenario { should_not be_valid }
  end

  feature "when email address with mixed case" do
    given(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    scenario "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end
end