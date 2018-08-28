class MovieTicket < ApplicationRecord
  acts_as_paranoid
  belongs_to :seat
  belongs_to :order
  belongs_to :screening

  validates :seat, presence: true
  validates :order, presence: true
  validates :screening, presence: true
end
