describe "Authorization" do

  describe "for non-signed-in users" do
    let(:user) { FactoryGirl.create(:user) }

    describe "in the Users controller" do

      describe "submitting to the update action" do
        before { put user_path(user) }
        it { response.should redirect_to(signin_url) }
      end
    end

    describe "when attempting to visit a protected page" do
      before do
        get edit_user_path(user)
        post sessions_path, email: user.email, password: user.password
      end

      describe "after signing in" do

        describe "when signing in again" do
          before do
            delete signout_path
            post sessions_path, email: user.email, password: user.password
          end

          it { response.should redirect_to(user_url user)}
        end
      end
    end
  end

  describe "as wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

    before { post sessions_path, email: user.email, password: user.password }

    describe "submitting a PUT request to the Users#update action" do
      before { put user_path(wrong_user) }
      it { response.should redirect_to(root_url) }
    end
  end

  describe "as valid user" do
    let(:user) { FactoryGirl.create(:user) }

    before { post sessions_path, email: user.email, password: user.password }

    describe "submitting a POST request to the Users#create action" do
      before { post users_path }
      it { response.should redirect_to(root_url) }
    end

    describe "submitting a GET request to the Users#new action" do
      before { get new_user_path }
      it { response.should redirect_to(root_url) }
    end
  end

  describe "as non-admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }

    before { post sessions_path, email: non_admin.email, password: non_admin.password }

    describe "submitting a DELETE request to the Users#destroy action" do
      before { delete user_path(user) }
      specify { response.should redirect_to(root_url) }
    end
  end

  describe "as admin user" do
    let(:admin) { FactoryGirl.create(:admin) }

    before { post sessions_path, email: admin.email, password: admin.password }

    specify "submitting a DELETE request to destroy himself" do
      expect { delete user_path(admin) }.not_to change(User, :count)
    end
  end
end