require 'spec_helper'

feature User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "qazwsx", password_confirmation: "qazwsx") }

  subject { @user }

  scenario { should respond_to(:name) }
  scenario { should respond_to(:email) }
  scenario { should respond_to(:password_digest) }
  scenario { should respond_to(:password) }
  scenario { should respond_to(:password_confirmation) }
  scenario { should respond_to(:authenticate) }

  scenario { should be_valid }

  feature "when name is not present" do
    before { @user.name = " " }
    scenario { should_not be_valid }
  end

  feature "when name is too long" do
    before { @user.name = "a" * 51 }
    scenario { should_not be_valid }
  end

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

  feature "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    scenario "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

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

  feature "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    feature "with valid password" do
      scenario { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      scenario { should_not == user_for_invalid_password }
      scenario { user_for_invalid_password.should == false }
    end
  end
end