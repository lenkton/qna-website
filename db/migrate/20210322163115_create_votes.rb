class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :votable, null: false, polymorphic: true
      t.integer :value, null: false

      t.index %i[author_id votable_id votable_type], unique: true

      t.timestamps
    end
  end
end
