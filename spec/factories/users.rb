# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email_address   :string
#  password_digest :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (lower((email_address)::text)) UNIQUE WHERE (email_address IS NOT NULL)
#  index_users_on_username       (lower((username)::text)) UNIQUE
#
FactoryBot.define do
  factory :user do
    email_address { FFaker::Internet.email }
    password { "password" }
    username { FFaker::Name.first_name + "1" }

    trait :temporary do
      email_address { nil }
    end

    trait :with_avatar do
      avatar { fixture_file_upload('image.png') }
    end
  end
end
