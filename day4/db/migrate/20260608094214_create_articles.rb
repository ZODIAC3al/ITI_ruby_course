class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.boolean :public, default: true
      t.boolean :archived, default: false
      t.integer :reports_count, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
