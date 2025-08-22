# == Schema Information
#
# Table name: tic_tac_toe_lobbies
#
#  id         :bigint           not null, primary key
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tic_tac_toe_lobby, class: 'TicTacToe::Lobby' do
    title { "MyText" }
  end
end
