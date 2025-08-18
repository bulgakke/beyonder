# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  body          :text
#  resource_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :bigint           not null
#  resource_id   :bigint           not null
#
# Indexes
#
#  index_posts_on_author_id  (author_id)
#  index_posts_on_resource   (resource_type,resource_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
FactoryBot.define do
  factory :post do
    body { FFaker::Loren.paragraph }
    author { user }
    resource { user }
  end
end
