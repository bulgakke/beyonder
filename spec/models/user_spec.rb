require 'rails_helper'

RSpec.describe User, type: :model do
  describe ".create" do
    describe "validations" do
      let(:user) { User.new(params).tap(&:validate) }

      context "without username and password" do
        let(:params) { {} }
        let(:expected_errors) do
          {
            password: ["can't be blank"],
            username: ["can't be blank"]
          }
        end

        it "cannot create user" do
          expect(user.errors.messages).to eq(expected_errors)
        end

        context "with blank username and password" do
          let(:params) { { username: "", password: "" } }

          it "cannot create user" do
            expect(user.errors.messages).to eq(expected_errors)
          end
        end
      end

      context "with username and password present" do
        let(:params) { { username: "1", password: "2" } }

        it "creates user" do
          expect(user).to be_valid
        end
      end
    end
  end
end
