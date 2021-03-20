class CreateRewardings < ActiveRecord::Migration[6.1]
  def change
    create_table :rewardings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true

      t.timestamps
    end
  end
end
