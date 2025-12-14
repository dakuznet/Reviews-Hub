class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false
      t.text :text, null: false
      t.references :user, null: false, foreign_key: true
      t.string :reviewable_type, null: false
      t.bigint :reviewable_id, null: false

      t.timestamps
    end

    # Индекс для полиморфной связи
    add_index :reviews, [:reviewable_type, :reviewable_id]
    
    # Индекс для уникальности: один пользователь - один отзыв на произведение
    add_index :reviews, [:user_id, :reviewable_type, :reviewable_id], unique: true, name: 'idx_user_reviewable'
  end
end