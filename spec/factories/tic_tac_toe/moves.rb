FactoryBot.define do
  factory :tic_tac_toe_move, class: 'TicTacToe::Move' do
    player { nil }
    game { nil }
  end
end
