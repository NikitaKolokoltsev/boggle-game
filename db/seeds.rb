# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Adding words from dictionary: #{ENV['DICTIONARY_PATH']} ..."

words = []

File.open(Rails.root.join(ENV['DICTIONARY_PATH'])).each do |word|
  words << Word.new(value: word.strip)
end

Word.import(words)

puts "Words added."