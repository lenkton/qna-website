class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :question, null: false, foreign_key: true
      t.boolean :supportive, null: false

      t.index %i[author_id question_id], unique: true

      t.timestamps
    end
  end
end
