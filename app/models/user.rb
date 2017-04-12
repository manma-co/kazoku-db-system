class User < ApplicationRecord

  before_save {self.email_pc = email_pc.downcase}
  before_save {self.email_phone = email_phone.downcase}

  validates :name, presence: true, length: {maximum: 20}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email_pc, presence: true, length: {maximum: 250},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :tel, length: {minimum: 10, maximum: 12}, allow_blank: true, uniqueness: true
  validates :sex, presence: true
end
