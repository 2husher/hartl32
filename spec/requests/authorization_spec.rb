describe "Authorization" do

  describe "for non-signed-in users" do
    let(:user) { FactoryGirl.create(:user) }

    describe "in the Users controller" do

      describe "submitting to the update action" do
        before { put user_path(user) }
        it { response.should redirect_to(signin_path) }
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

  describe "as non-admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }

    before { post sessions_path, email: non_admin.email, password: non_admin.password }

    describe "submitting a DELETE request to the Users#destroy action" do
      before { delete user_path(user) }
      specify { response.should redirect_to(root_url) }
    end
  end
end