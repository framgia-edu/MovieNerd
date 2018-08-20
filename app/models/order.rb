class Order < ApplicationRecord
  belongs_to :user
  belongs_to :screening
  has_many :movie_tickets
  has_many :seats, through: :movie_tickets

  validates :user, presence: true
  validates :screening, presence: true
end
