class AddScreeningToMovieTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :movie_tickets, :screening, foreign_key: true
    add_index :movie_tickets, [:seat_id, :screening_id], unique: true
  end
end
