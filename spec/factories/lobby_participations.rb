# == Schema Information
#
# Table name: lobby_participations
#
#  id         :bigint           not null, primary key
#  lobby_type :string           not null
#  ready      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lobby_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  idx_on_user_id_lobby_id_lobby_type_3f6e8c8406  (user_id,lobby_id,lobby_type) UNIQUE
#  index_lobby_participations_on_lobby            (lobby_type,lobby_id)
#  index_lobby_participations_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :lobby_participation do
    user { nil }
    lobby { nil }
  end
end
