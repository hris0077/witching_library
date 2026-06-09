# == Schema Information
#
# Table name: members
#
#  id              :bigint           not null, primary key
#  email           :string
#  full_name       :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :member do
    full_name { "MyString" }
    password_digest { "MyString" }
    email { "MyString" }
  end
end
