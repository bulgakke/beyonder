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
class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :resource, polymorphic: true

  normalizes :body, with: ->(body) { body.strip }

  validates :body, presence: true
end
