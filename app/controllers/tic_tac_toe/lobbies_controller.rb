module TicTacToe
  class LobbiesController < ApplicationController
    before_action :set_lobby, only: %i[show join leave start]

    def index
    end

    def show
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
    end
  end
end
