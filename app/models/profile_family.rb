class ProfileFamily < ApplicationRecord
  belongs_to :user
  has_many :profile_individuals, dependent: :destroy

  enum job_styles: {
    "#{Settings.job_style.str.none}": -1,
    "#{Settings.job_style.str.both}": 0,
    "#{Settings.job_style.str.both_single}": 1,
    "#{Settings.job_style.str.homemaker}": 2
  }

  enum available_statuses: {
    "#{Settings.is_photo.str.ng}": 0,
    "#{Settings.is_photo.str.ok}": 1,
    "#{Settings.is_photo.str.caution}": 2
  }

  # 同一クラス内に同一のキーを持つenumは生成できない
  # ex) "どちらも経験無し": n が違うenumで提議したとしても複数存在するのはNG
  def self.has_experience_abroads
    {
      "#{Settings.has_experience_abroads.str.abroad_and_work}": 0,
      "#{Settings.has_experience_abroads.str.abroad_only}": 1,
      "#{Settings.has_experience_abroads.str.work_only}": 2,
      "#{Settings.has_experience_abroads.str.none}": 3
    }
  end

  def self.has_time_shortening_experiences
    {
      "#{Settings.has_time_shortening_experiences.str.both}": 0,
      "#{Settings.has_time_shortening_experiences.str.mother_only}": 1,
      "#{Settings.has_time_shortening_experiences.str.father_only}": 2,
      "#{Settings.has_time_shortening_experiences.str.none}": 3
    }
  end

  def self.has_childcare_leave_experiences
    {
      "#{Settings.has_childcare_leave_experiences.str.both}": 0,
      "#{Settings.has_childcare_leave_experiences.str.mother_only}": 1,
      "#{Settings.has_childcare_leave_experiences.str.father_only}": 2,
      "#{Settings.has_childcare_leave_experiences.str.none}": 3
    }
  end

  def self.has_job_change_experiences
    {
      "#{Settings.has_job_change_experiences.str.both}": 0,
      "#{Settings.has_job_change_experiences.str.mother_only}": 1,
      "#{Settings.has_job_change_experiences.str.father_only}": 2,
      "#{Settings.has_job_change_experiences.str.none}": 3
    }
  end

  enum is_male_ok_statuses: {
    "#{Settings.is_male.str.ng}": 0,
    "#{Settings.is_male.str.ok}": 1
  }
end
