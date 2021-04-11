class CreateSubscribings < ActiveRecord::Migration[6.1]
  def change
    create_table :subscribings do |t|
      t.references :subscriber, null: false, foreign_key: { to_table: :users }
      t.references :subscription, null: false, foreign_key: { to_table: :questions }

      t.index %i[subscription_id subscriber_id], unique: true

      t.timestamps
    end
  end
end
