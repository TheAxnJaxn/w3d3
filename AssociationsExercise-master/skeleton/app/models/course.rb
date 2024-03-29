# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  prereq_id     :integer
#  instructor_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Course < ActiveRecord::Base
  has_many     :enrollments, {
                foreign_key: :course_id,
                primary_key: :id,
                class_name: "Enrollment"
              }

  has_many :enrolled_students, through: :enrollments, source: :student

  has_one :prerequisite, foreign_key: :prereq_id, primary_key: :id, class_name: "Course"
  belongs_to :instructor, foreign_key: :instructor_id, primary_key: :id, class_name: "User"
end
