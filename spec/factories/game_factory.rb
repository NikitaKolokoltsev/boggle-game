FactoryBot.define do
  factory :game do
    board { ['T', 'A', 'P', '*', 'E', 'A', 'K', 'S', 'A', 'B', 'R', 'S', 'S', '*', 'X', 'D'] }
    duration { 100 }
  end
end
