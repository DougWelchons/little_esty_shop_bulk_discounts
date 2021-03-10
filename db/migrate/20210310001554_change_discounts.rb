class ChangeDiscounts < ActiveRecord::Migration[5.2]
  def change
    change_column :discounts, :percent, :integer
  end
end
