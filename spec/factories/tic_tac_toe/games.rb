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
FactoryBot.define do
  factory :tic_tac_toe_game, class: 'TicTacToe::Game' do
    x_player { nil }
    o_player { nil }
  end
end
