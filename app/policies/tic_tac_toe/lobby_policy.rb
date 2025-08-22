module TicTacToe
  class LobbyPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.all
      end
    end

    def index?
      true
    end

    def show?
      true
    end

    def create?
      true
    end

    def join?
      true
    end

    def leave?
      true
    end

    def start?
      true
    end
  end
end
