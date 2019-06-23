class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true, null: false
      t.references :movie, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
