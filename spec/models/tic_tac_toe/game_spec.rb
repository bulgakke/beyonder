# == Schema Information
#
# Table name: tic_tac_toe_games
#
#  id          :bigint           not null, primary key
#  board       :jsonb            not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  o_player_id :bigint           not null
#  x_player_id :bigint           not null
#
# Indexes
#
#  index_tic_tac_toe_games_on_o_player_id  (o_player_id)
#  index_tic_tac_toe_games_on_x_player_id  (x_player_id)
#
# Foreign Keys
#
#  fk_rails_...  (o_player_id => users.id)
#  fk_rails_...  (x_player_id => users.id)
#
require 'rails_helper'

RSpec.describe TicTacToe::Game, type: :model do
  let(:x_player) { create(:user) }
  let(:o_player) { create(:user) }

  describe "#make_move" do
    shared_examples "an invalid move" do
      it "returns false" do
        expect(make_move).to be false
      end

      it "does not register the move" do
        expect { make_move }.not_to change(game.moves, :count)
      end

      it "does not update the board" do
        expect { make_move }.not_to change(game, :board)
      end

      it "does not update the Game record" do
        expect { make_move }.not_to change(game, :updated_at)
      end

      it "adds an error" do
        make_move
        expect(game.errors[:base]).to include(expected_error)
      end
    end

    let(:game) do
      create(:tic_tac_toe_game, x_player:, o_player:).tap do |g|
        g.make_move(x_player, 0, 0)
      end
    end

    context "when move is valid" do
      subject(:make_move) { game.make_move(o_player, 1, 1) }

      it "returns true" do
        expect(make_move).to be true
      end

      it "registers the move" do
        expect { make_move }.to change(game.moves, :count).by(1)

        expect(game.moves.last.player).to eq o_player
        expect(game.moves.last.row).to eq 1
        expect(game.moves.last.column).to eq 1
      end

      it "updates the board" do
        expect { make_move }.to change(game, :board).from([
          ["x", nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]).to([
          ["x", nil, nil],
          [nil, "o", nil],
          [nil, nil, nil]
        ])
      end

      it "updates the Game record" do
        previous_board = game.board

        expect { make_move }.to change(game, :updated_at)
        expect(game.persisted?).to be true
        expect(game.reload.board).not_to eq previous_board
      end
    end

    context "when move is invalid" do
      context "when position is already filled" do
        subject(:make_move) { game.make_move(o_player, 0, 0) }

        let(:expected_error) { "Invalid move" }

        it_behaves_like "an invalid move"
      end

      context "when same player moves two times in a row" do
        subject(:make_move) { game.make_move(x_player, 1, 1) }

        let(:expected_error) { "Can't move two times in a row" }

        it_behaves_like "an invalid move"
      end

      context "when player is not a game participant" do
        subject(:make_move) { game.make_move(create(:user), 1, 1) }

        let(:expected_error) { "Invalid player" }

        it_behaves_like "an invalid move"
      end
    end
  end

  describe "game process" do
    let(:game) { create(:tic_tac_toe_game, x_player:, o_player:) }

    it "example 1" do
      game.make_move(x_player, 0, 0)
      game.make_move(o_player, 1, 1)
      game.make_move(x_player, 0, 2)

      expect(game.ended?).to be false
      expect(game.full?).to be false
      expect(game.winner).to be nil

      game.make_move(o_player, 0, 1)
      game.make_move(x_player, 2, 0)
      game.make_move(o_player, 2, 1)

      expect(game.board).to eq [
        ["x", "o", "x"],
        [nil, "o", nil],
        ["x", "o", nil]
      ]
      expect(game.ended?).to be true
      expect(game.full?).to be false
      expect(game.winner).to eq o_player
    end

    it "example 2" do
      game.make_move(x_player, 1, 1)
      game.make_move(o_player, 0, 0)
      game.make_move(x_player, 0, 2)
      game.make_move(o_player, 2, 0)

      expect(game.ended?).to be false
      expect(game.full?).to be false
      expect(game.winner).to eq nil

      game.make_move(x_player, 1, 0)
      game.make_move(o_player, 1, 2)
      game.make_move(x_player, 2, 1)
      game.make_move(o_player, 0, 1)
      game.make_move(x_player, 2, 2)

      expect(game.board).to eq [
        ["o", "o", "x"],
        ["x", "x", "o"],
        ["o", "x", "x"]
      ]

      expect(game.ended?).to be true
      expect(game.full?).to be true
      expect(game.winner).to eq nil
    end
  end
end
