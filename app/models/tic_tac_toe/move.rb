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
