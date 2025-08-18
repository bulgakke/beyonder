# == Schema Information
#
# Table name: sessions
#
#  id            :bigint           not null, primary key
#  ip_address    :string
#  last_login_at :datetime         not null
#  user_agent    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Session < ApplicationRecord
  EXPIRATION_PERIOD = 1.week.freeze
  LAST_LOGIN_UPDATE_PERIOD = 1.hour.freeze

  belongs_to :user

  scope :not_expired, -> { where("last_login_at > ?", EXPIRATION_PERIOD.ago) }
  scope :expired, -> { where("last_login_at < ?", EXPIRATION_PERIOD.ago) }

  # Periodically update last_login_at
  def refresh_last_login!
    return true if last_login_at > LAST_LOGIN_UPDATE_PERIOD.ago

    update!(last_login_at: Time.current)
  end
end
