class Order < ApplicationRecord
  acts_as_paranoid
  enum paid: [:paid, :unpaid]
  after_destroy :send_mail, if: :affected_2_user?

  belongs_to :user
  belongs_to :screening
  has_many :movie_tickets, dependent: :destroy
  has_many :seats, through: :movie_tickets

  validates :user, presence: true
  validates :screening, presence: true
  validates :paid, presence: true

  def delete_unpaid
    really_destroy! if unpaid?
  end
  handle_asynchronously :delete_unpaid, run_at: proc{5.minutes.from_now}

  def show_seats
    str = []
    seats.each do |seat|
      str.push(" #{I18n.t('seats.row')}#{seat.row}x"\
        "#{I18n.t('seats.number')}#{seat.number} ")
      str.push "||"
    end
    str.pop
    str
  end

  def user_deleted
    user || User.with_deleted.find_by(id: user_id)
  end

  def screening_deleted
    screening || Screening.with_deleted.find_by(id: screening_id)
  end

  def affected_2_user?
    paid? && screening_in_future?
  end

  private

  def send_mail
    if Rails.env.development?
      OrderDeletedWorker.perform_async id
    else
      UserMailer.order_deleted(self).deliver_now
    end
  end

  def screening_in_future?
    screening.screening_start.present? && screening.screening_start > Time.now
  end
end
