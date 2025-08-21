# Things not needed for application to work, but improve
# development/debugging
module ConvenienceMethods
  extend ActiveSupport::Concern

  class_methods do
    # Shortcut for finding users by username
    #
    # @example
    #   User.count # => 0
    #   User.create!(username: "coolhecker_1337")
    #   User[:coolhecker] # => #<User id: 1, username: "coolhecker_1337", ... >
    def [](username)
      where("username ILIKE ?", "#{username}%").first
    end
  end
end
