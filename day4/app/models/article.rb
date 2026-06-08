class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true
  validates :body, presence: true

  before_save :archive_if_reported_limit, if: :reports_count_changed?

  private

  def archive_if_reported_limit
    if reports_count >= 3
      self.archived = true
    end
  end
end
