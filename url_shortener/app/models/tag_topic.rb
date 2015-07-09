# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  topic      :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class TagTopic < ActiveRecord::Base
  has_many :taggings, foreign_key: :topic_id, primary_key: :id, class_name: "Tagging"
  has_many(
    :urls,
     through: :taggings,
     source: :url
     )
end
