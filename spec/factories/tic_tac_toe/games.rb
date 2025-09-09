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
FactoryBot.define do
  factory :tic_tac_toe_game, class: 'TicTacToe::Game' do
    x_player { nil }
    o_player { nil }
    status { :pending }
    lobby { build(:tic_tac_toe_lobby) }

    trait :with_full_board do
      x_player { create(:user) }
      o_player { create(:user) }

      board do
        [
          ["x", "o", "x"],
          ["o", "x", "o"],
          ["x", "o", "x"]
        ]
      end

      moves do
        TicTacToe::Move.build [
          { row: 0, column: 0, player: x_player, symbol: :x },
          { row: 0, column: 1, player: o_player, symbol: :o },
          { row: 0, column: 2, player: x_player, symbol: :x },
          { row: 1, column: 0, player: o_player, symbol: :o },
          { row: 1, column: 1, player: x_player, symbol: :x },
          { row: 1, column: 2, player: o_player, symbol: :o },
          { row: 2, column: 0, player: x_player, symbol: :x },
          { row: 2, column: 1, player: o_player, symbol: :o },
          { row: 2, column: 2, player: x_player, symbol: :x }
        ]
      end
    end
  end
end
