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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe ".create" do
    describe "validations" do
      let(:user) { User.new(params).tap(&:validate) }

      context "with blank username and password" do
        let(:params) { { username: "", password: "" } }
        let(:expected_errors) do
          {
            password: ["can't be blank"],
            username: [
              "can't be blank",
              "can only contain Latin letters, numbers and underscores",
              "is too short (minimum is 3 characters)"
            ]
          }
        end

        it "cannot create user" do
          expect(user.errors.messages).to eq(expected_errors)
        end
      end

      context "with username and password present" do
        let(:params) { { username: "123", password: "2" } }

        it "creates user" do
          expect(user).to be_valid
        end
      end
    end
  end
end
