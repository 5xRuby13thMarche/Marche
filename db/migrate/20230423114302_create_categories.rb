class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :content
      t.references :parent, null: true, foreign_key: { to_table: :categories }

      t.timestamps
    end
  end
end
