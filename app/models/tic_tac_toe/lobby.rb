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

  has_one :game

  has_many :lobby_participations
  has_many :users, through: :lobby_participations

  def status
    game&.status || "Waiting for players"
  end

  def title
    read_attribute(:title) || "TicTacToe Lobby ##{id}"
  end

  def host
    lobby_participations.order(created_at: :asc).first.user
  end

  def max_players = MAX_PLAYERS

  def ready?
    lobby_participations.all?(&:ready?)
  end

  def full?
    users.count >= MAX_PLAYERS
  end
end
