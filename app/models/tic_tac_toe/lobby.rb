# == Schema Information
#
# Table name: tic_tac_toe_lobbies
#
#  id         :bigint           not null, primary key
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TicTacToe::Lobby < ApplicationRecord
  MAX_PLAYERS = 2

  has_many :lobby_participations
  has_many :users, through: :lobby_participations

  def full?
    users.count >= MAX_PLAYERS
  end
end
