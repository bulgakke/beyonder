require "rails_helper"

RSpec.describe RemoveTemporaryUsersJob, type: :job do
  describe "#perform" do
    let!(:registered_user_with_expired_session) do
      create(:session, :expired).user
    end

    let!(:registered_user_with_active_session) do
      create(:session).user
    end

    let!(:registered_user_without_session) do
      create(:user)
    end

    let!(:temporary_user_with_expired_session) do
      create(:user, :temporary).tap do |user|
        create(:session, :expired, user:)
      end
    end

    let!(:temporary_user_with_active_session) do
      create(:user, :temporary).tap do |user|
        create(:session, user:)
      end
    end

    let!(:temporary_user_without_session) do
      create(:user, :temporary)
    end

    before { RemoveTemporaryUsersJob.perform_now }

    it "destroys temporary users without active sessions" do
      expect(User.all).to match_array([
        registered_user_with_expired_session,
        registered_user_with_active_session,
        registered_user_without_session,
        temporary_user_with_active_session
      ])
    end

    it "destroys their sessions" do
      expect(Session.all).to match_array([
        registered_user_with_active_session.sessions.first,
        registered_user_with_expired_session.sessions.first,
        temporary_user_with_active_session.sessions.first
      ])
    end
  end
end
