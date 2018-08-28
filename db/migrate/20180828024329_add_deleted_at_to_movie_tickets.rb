class AddDeletedAtToMovieTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :movie_tickets, :deleted_at, :datetime
    add_index :movie_tickets, :deleted_at
  end
end
