class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :username, presence: true

  scope :registered, -> { where.not(email_address: nil) }

  def registered?
    email_address.present?
  end

  def guest?
    !registered?
  end
end
