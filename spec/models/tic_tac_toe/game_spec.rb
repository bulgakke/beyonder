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
require 'rails_helper'

RSpec.describe TicTacToe::Game, type: :model do
  let(:x_player) { create(:user) }
  let(:o_player) { create(:user) }

  describe "AASM" do
    let(:game) { create(:tic_tac_toe_game, x_player:, o_player:) }

    shared_examples "an invalid transition" do |action|
      it "does not #{action} the game" do
        expect(game.public_send("may_#{action}?")).to be false
        expect { game.public_send(action) }.to raise_error(AASM::InvalidTransition)
      end
    end

    it "starts as pending" do
      expect(game.status).to eq "pending"
    end

    describe "#start!" do
      context "when both players are present" do
        it "starts the game" do
          game.start!
          expect(game.status).to eq "ongoing"
        end
      end

      context "when game is ongoing" do
        before { game.start! }

        it_behaves_like "an invalid transition", "start"
      end

      context "when game is finished" do
        let(:game) { create(:tic_tac_toe_game, :with_full_board, status: :finished) }

        it_behaves_like "an invalid transition", "start"
      end
    end

    describe "#finish!" do
      let(:game) { create(:tic_tac_toe_game, :with_full_board, status:) }

      context "when game is ongoing" do
        let(:status) { :ongoing }

        context "when board is full or there is a winner" do
          it "finishes the game" do
            game.finish!
            expect(game.status).to eq "finished"
          end
        end

        context "when board is not full and there is no winner" do
          let(:game) { create(:tic_tac_toe_game, status:, x_player:, o_player:) }

          it_behaves_like "an invalid transition", "finish"
        end
      end

      context "when game is finished" do
        let(:status) { :finished }

        it_behaves_like "an invalid transition", "finish"
      end

      context "when game is pending" do
        let(:status) { :pending }

        it_behaves_like "an invalid transition", "finish"
      end
    end
  end

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
        g.start!
        g.make_move(x_player, 0, 0)
      end
    end

    context "when move is valid" do
      subject(:make_move) { game.make_move(o_player, 1, 1) }

      context "when game is not ongoing" do
        let(:game) { create(:tic_tac_toe_game, x_player:, o_player:, status:) }
        let(:expected_error) { "Game must be ongoing" }

        context "when game is pending" do
          let(:status) { :pending }

          it_behaves_like "an invalid move"
        end

        context "when game is finished" do
          let(:status) { :finished }

          it_behaves_like "an invalid move"
        end
      end

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
    let(:game) { create(:tic_tac_toe_game, x_player:, o_player:).tap { it.start } }

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
