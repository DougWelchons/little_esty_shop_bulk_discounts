class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.decimal :percent
      t.integer :threshold
      t.integer :status, default: 0
      t.references :merchants, foreign_key: true

      t.timestamps
    end
  end
end
