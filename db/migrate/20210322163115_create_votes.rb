class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.boolean :supportive, null: false

      t.index %i[user_id question_id], unique: true

      t.timestamps
    end
  end
end
