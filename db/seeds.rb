# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# 建立五個主分類
5.times do
  main_category = Category.create!(content: Faker::Commerce.department, parent_id: 0)

  # 在每個主分類下建立五個子分類
  5.times do
    Category.create!(content: Faker::Commerce.department, parent_id: main_category.id)
  end
end



puts "Categories假資料生成完成!"



