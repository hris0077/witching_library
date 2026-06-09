# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email_address   :string           not null
#  first_name      :string
#  last_name       :string
#  password_digest :string           not null
#  timezone        :string           default("UTC")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :loan, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :password, length: { in: 6..20 }
  validates :password, confirmation: true, unless: -> { password.blank? }
  validates :password_confirmation, presence: true, on: :create
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true
end
