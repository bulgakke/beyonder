require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  before do
    post session_url, params: { login: user.email_address, password: 'password' }
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe "GET /me" do
    it "redirects to current user page" do
      get me_url
      expect(response).to redirect_to(user_url(user))
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_attributes) {
        { username: "username" }
      }

      it "creates a new User" do
        expect {
          post users_url, params: valid_attributes
        }.to change(User, :count).by(1)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        { username: "a" * 21 }
      }

      it "does not create a new User" do
        expect {
          post users_url, params: invalid_attributes
        }.to change(User, :count).by(0)
      end

      it "redirects to session#new" do
        post users_url, params: invalid_attributes
        expect(response).to redirect_to(new_session_url(active_tab: "quick-login"))
      end
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) {
      { avatar: }
    }

    context "with valid parameters" do
      let(:avatar) { fixture_file_upload("image.png", "image/png") }

      it "updates the requested user" do
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.avatar.attached?).to be true
      end
    end

    context "with invalid parameters" do
      let(:avatar) { fixture_file_upload("image.svg", "image/svg+xml") }

      xit "renders a response with 422 status" do
        patch user_url(user), params: { user: new_attributes }
        expect(response).to have_http_status(:unprocessable_content)
        expect(user.avatar.attached?).to be false
      end
    end
  end
end
