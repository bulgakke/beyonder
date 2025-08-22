# == Schema Information
#
# Table name: tic_tac_toe_lobbies
#
#  id         :bigint           not null, primary key
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe TicTacToe::Lobby, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
