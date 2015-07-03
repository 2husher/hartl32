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
  scenario { should respond_to(:remember_token) }
  scenario { should respond_to(:admin) }
  scenario { should respond_to(:authenticate) }
  scenario { should respond_to(:microposts) }

  scenario { should be_valid }
  scenario { should_not be_admin }
end