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
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Allow nil emails for temporary accounts, validate if not nil
  validates :email_address,
    presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false },
    unless: -> { email_address.nil? }

  validates :username,
    presence: true,
    format: { with: /\A\w+\z/, message: "can only contain Latin letters, numbers and underscores" },
    uniqueness: { case_sensitive: false }

  scope :registered, -> { where.not(email_address: nil) }
  scope :temporary, -> { where(email_address: nil) }

  def self.authenticate_by_login(attributes)
    login = attributes.delete(:login)

    if login.match?(/@/)
      attributes[:email_address] = login
    else
      attributes[:username] = login
    end

    authenticate_by(attributes)
  end

  # Enables URL helpers to correctly form links
  def to_param
    username
  end

  def registered?
    email_address.present?
  end

  def temporary?
    !registered?
  end
end
