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
      unless @lobby.users.include?(Current.user)
        @lobby.lobby_participations.create!(user: Current.user)
      end

      respond_to do |format|
        format.turbo_stream { render "lobbies/update", locals: { lobby: @lobby } }
        format.html { redirect_to tic_tac_toe_lobby_path(@lobby) }
      end
    end

    def leave
      @lobby.lobby_participations.where(user: Current.user).destroy_all

      respond_to do |format|
        format.turbo_stream { render "lobbies/update", locals: { lobby: @lobby } }
        format.html { redirect_to tic_tac_toe_lobby_path(@lobby) }
      end
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
