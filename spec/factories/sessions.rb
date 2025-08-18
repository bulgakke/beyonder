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
FactoryBot.define do
  factory :session do
    user
    user_agent { FFaker::Lorem.word }
    ip_address { FFaker::Internet.ip_v4_address }
    last_login_at { Time.now }

    trait :expired do
      last_login_at { 1.year.ago }
    end
  end
end
