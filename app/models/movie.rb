class Movie < ApplicationRecord
  extend FriendlyId
  include PgSearch
  friendly_id :title, use: :slugged
  enum rated: [:G, :PG, :PG13, :R, :NC17]

  has_many :screenings, dependent: :destroy
  has_many :rooms, through: :screenings
  mount_uploader :picture, PictureUploader
  validates :title, presence: true,
    length: {maximum: Settings.title_max_length},
    uniqueness: {case_sensitive: false}
  validates :director, presence: true
  validates :cast, presence: true
  validates :description, presence: true
  validates :language, presence: true
  validates :genre, presence: true
  validates :release_date, presence: true
  validates :rated, presence: true
  validates :duration, presence: true
  validates :picture, presence: true
  validate :time_duration
  validate :picture_size
  scope :with_title, ->(title){where "LOWER(title) like ?", "%#{title}%"}
  scope :home_movie, ->{order release_date: :desc}
  scope :movie_by_day, (lambda do |date|
    Movie.where(id: Screening.select(:movie_id).where("screening_start >= ?"\
     " AND screening_start < ?", date, date.tomorrow).distinct)
  end)
  scope :showing, (lambda do
    Movie.where(id: Screening.select(:movie_id).where("screening_start >= ? "\
      "AND screening_start < ?", Date.today,
      Date.today + Settings.movie.showing_day).distinct)
  end)
  scope :coming, (lambda do
    Movie.where("release_date >= ?", Date.today).where.not(id:
      Screening.select(:movie_id).where("screening_start >= ? AND"\
      " screening_start < ?", Date.today,
        Date.today + Settings.movie.showing_day).distinct)
  end)
  pg_search_scope :full_text_search,
    against: {
      title: "A",
      cast: "B",
      director: "C",
      description: "D"
    },
    using: {
      tsearch: {prefix: true},
      trigram: {}
    }
  before_save :beatify

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  private
  def beatify
    self.title = title.titleize
    self.director = director.titleize
    self.cast = cast.titleize
    self.genre = genre.titleize
    self.description = description.upcase_first
  end

  def time_duration
    return unless duration.present? && duration <= 0
    errors.add :duration,
      I18n.t("activerecord.errors.models.movie.attributes.duration.invalid")
  end

  def picture_size
    return if picture.size < Settings.movie.picture_size.megabytes
    errors.add :picture, I18n.t("movie.picture_size_error")
  end
end
