module TicTacToe
  class LobbiesController < ApplicationController
    before_action :set_lobby, only: %i[show join leave start]

    def index
      @lobbies = policy_scope(Lobby)

      render "lobbies/index"
    end

    def show
      render "lobbies/show"
    end

    def create
    end

    def join
    end

    def leave
    end

    def start
    end

    private

    def set_lobby
      @lobby = Lobby.find(params[:id])

      authorize @lobby
    end
  end
end
