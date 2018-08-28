class AddDeletedAtToSeats < ActiveRecord::Migration[5.2]
  def change
    add_column :seats, :deleted_at, :datetime
    add_index :seats, :deleted_at
  end
end
