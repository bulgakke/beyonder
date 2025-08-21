# == Schema Information
#
# Table name: tic_tac_toe_moves
#
#  id         :bigint           not null, primary key
#  column     :integer          not null
#  row        :integer          not null
#  symbol     :enum             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_tic_tac_toe_moves_on_game_id    (game_id)
#  index_tic_tac_toe_moves_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => tic_tac_toe_games.id)
#  fk_rails_...  (player_id => users.id)
#
FactoryBot.define do
  factory :tic_tac_toe_move, class: 'TicTacToe::Move' do
    player { nil }
    game { nil }
  end
end
