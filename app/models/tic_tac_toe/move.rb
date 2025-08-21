# == Schema Information
#
# Table name: tic_tac_toe_moves
#
#  id         :bigint           not null, primary key
#  column     :integer          not null
#  row        :integer          not null
#  symbol     :enum             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_tic_tac_toe_moves_on_game_id    (game_id)
#  index_tic_tac_toe_moves_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => tic_tac_toe_games.id)
#  fk_rails_...  (player_id => users.id)
#
module TicTacToe
  class Move < ApplicationRecord
    belongs_to :game
    belongs_to :player, class_name: "User"

    enum :symbol, x: "x", o: "o"

    validates :row, :column, :symbol, presence: true
    validate :validate_move_uniqueness

    default_scope { order(created_at: :asc) }

    private

    def validate_move_uniqueness
      errors.add(:base, "Move already exists") if game.moves.exists?(row: row, column: column)
    end
  end
end
