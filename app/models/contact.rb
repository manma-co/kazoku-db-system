class Contact < ApplicationRecord
  belongs_to :user

  before_save {self.email_pc = email_pc.downcase}
  before_save {self.email_phone = email_phone.downcase}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email_pc, presence: true, length: {maximum: 250},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
end
