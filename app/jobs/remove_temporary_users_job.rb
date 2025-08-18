class RemoveTemporaryUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    users = User.temporary.left_joins(:sessions)

    users_to_destroy = users.where(sessions: { id: nil }).or(
      users.where("sessions.last_login_at < ?", Session::EXPIRATION_PERIOD.ago)
    )

    users_to_destroy.destroy_all
  end
end
