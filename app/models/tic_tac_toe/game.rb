# == Schema Information
#
# Table name: tic_tac_toe_games
#
#  id          :bigint           not null, primary key
#  board       :jsonb            not null
#  status      :enum             default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lobby_id    :bigint           not null
#  o_player_id :bigint           not null
#  x_player_id :bigint           not null
#
# Indexes
#
#  index_tic_tac_toe_games_on_lobby_id     (lobby_id)
#  index_tic_tac_toe_games_on_o_player_id  (o_player_id)
#  index_tic_tac_toe_games_on_x_player_id  (x_player_id)
#
# Foreign Keys
#
#  fk_rails_...  (lobby_id => tic_tac_toe_lobbies.id)
#  fk_rails_...  (o_player_id => users.id)
#  fk_rails_...  (x_player_id => users.id)
#
module TicTacToe
  class Game < ApplicationRecord
    include AASM

    belongs_to :lobby
    belongs_to :x_player, class_name: "User", optional: true
    belongs_to :o_player, class_name: "User", optional: true

    has_many :moves, dependent: :destroy

    aasm column: :status do
      state :pending, initial: true
      state :ongoing
      state :finished

      event :start do
        transitions from: :pending, to: :ongoing, guard: :both_players_present?
      end

      event :finish do
        transitions from: :ongoing, to: :finished, guard: :ended?
      end
    end

    validate :players_are_not_the_same

    def both_players_present?
      x_player.present? && o_player.present?
    end

    def puts_board
      puts board.map { |row| row.map { |cell| cell || " " }.join("|") }.join("\n")
    end

    def full?
      board.all? { |row| row.all? { |cell| cell.present? } } && moves.count == 9
    end

    def ended?
      !!winner || full?
    end

    def rows
      board
    end

    def columns
      board.transpose
    end

    def diagonals
      [
        [board[0][0], board[1][1], board[2][2]],
        [board[0][2], board[1][1], board[2][0]]
      ]
    end

    def winner
      (rows + columns + diagonals).each do |line|
        return x_player if line.all?("x")
        return o_player if line.all?("o")
      end

      nil
    end

    def make_move(player, row, column)
      return false unless validate_move(player, row, column)

      symbol = player == x_player ? :x : :o

      transaction do
        moves.create!(row: row, column: column, player: player, symbol: symbol)
        board[row][column] = symbol

        save!
      end
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    def validate_move(player, row, column)
      errors.add(:base, "Game must be ongoing") unless ongoing?
      errors.add(:base, "Invalid move") if board[row][column].present?
      errors.add(:base, "Invalid player") if player != x_player && player != o_player
      errors.add(:base, "Can't move two times in a row") if moves.last&.player == player

      errors.blank?
    end

    def players_are_not_the_same
      if x_player.present? && x_player == o_player
        errors.add(:base, "Players cannot be the same")
      end
    end
  end
end
