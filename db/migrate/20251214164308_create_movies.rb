class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :director
      t.string :screenwriter
      t.string :producer
      t.integer :year
      t.string :genre
      t.text :description
      t.string :url
      t.integer :duration
      t.string :country
      t.string :studio
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
