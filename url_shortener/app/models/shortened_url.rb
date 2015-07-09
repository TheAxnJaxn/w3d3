# == Schema Information
#
# Table name: shortened_urls
#
#  id            :integer          not null, primary key
#  long_url      :string           not null
#  shortened_url :string
#  submitter_id  :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class ShortenedUrl < ActiveRecord::Base
  belongs_to :submitter, foreign_key: :submitter_id, primary_key: :id, class_name: "User"
  has_many :visits, foreign_key: :shortened_url_id, primary_key: :id, class_name: "Visit"
  has_many :taggings, foreign_key: :url_id, primary_key: :id, class_name: "Tagging"
  has_many(
    :visitors,
    Proc.new { distinct },
     through: :visits,
     source: :visitor
     )
   has_many(
     :tags,
      through: :taggings,
      source: :tag_topic
      )

  validates :long_url, :submitter_id, null: false
  validates :shortened_url, uniqueness: true
  validates :long_url, length: { maximum: 255 }
  validate :too_many_same_user

  def self.random_code
    str = SecureRandom.urlsafe_base64(16)
    while ShortenedUrl.exists?(shortened_url: str)
        str = SecureRandom.urlsafe_base64(16)
    end
    str
  end

  def self.create_for_user_and_long_url!(user, long_url)
    shortened = ShortenedUrl.random_code
    ShortenedUrl.create!(long_url: long_url, shortened_url: shortened, submitter_id: user.id)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    #visits.select(:user_id).distinct.count
    visitors.count
  end

  def num_recent_uniques
    visits.where(created_at: 10.minutes.ago..0.minutes.ago).select(:user_id).distinct.count
  end

  def self.prune
    # Note to self: not complete
    
    valid_time_range = 30.minutes.ago..0.minutes.ago
    #Join the Visits table with the shortened url table.
    #Filter to include only the visits within the time range.
    #Group the visits by url_id, and then output the list of urls that HAVE been visited in time range.
    #Take all your URLS, delete the ones that aren't in your subquery results above.
    #
    ShortenedUrl.joins(:visits).where('visits.created_at' => valid_time_range) #returns array


  end

  private

  def too_many_same_user
    return if submitter.is_premium # allows premium users to add > 5
    time_frame = 1.minute.ago..0.minutes.ago
    if ShortenedUrl.all.where(created_at: time_frame, submitter_id: submitter_id).count > 5
      errors[:submitter_id] << "can't submit more than 5 URLs in the last minute"
    end
  end

end
