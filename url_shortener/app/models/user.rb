# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime
#  updated_at :datetime
#  is_premium :boolean          default("f"), not null
#

class User < ActiveRecord::Base
  has_many :submitted_urls, foreign_key: :submitter_id, primary_key: :id, class_name: "ShortenedUrl"
  has_many :visits, foreign_key: :shortened_url_id, primary_key: :id, class_name: "Visit"
  has_many(
    :visited_urls,
    Proc.new { distinct },
    through: :visits,
    source: :visited_url)

   validates :email, presence: true, uniqueness: true

end
