class AddDeletedAtToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :deleted_at, :datetime
    add_index :movies, :deleted_at
  end
end
