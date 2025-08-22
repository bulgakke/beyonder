module TicTacToe
  class GamesController < ApplicationController
    before_action :set_game, only: %i[show make_move]

    def index
      @games = policy_scope Game
    end

    def show
    end

    def create
    end

    def make_move
    end

    private

    def set_game
      @game = Game.find(params[:id])

      authorize @game
    end
  end
end
