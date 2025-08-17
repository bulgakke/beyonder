class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :username,
    presence: true,
    format: { with: /\A\w+\z/ },
    uniqueness: { case_sensitive: false }

  scope :registered, -> { where.not(email_address: nil) }

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

  def guest?
    !registered?
  end
end
