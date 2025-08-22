module TicTacToe
  class GamePolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      true
    end

    def create?
      true
    end

    def make_move?
      [@record.x_player, @record.o_player].include? @user
    end
  end
end
