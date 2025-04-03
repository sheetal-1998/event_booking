class User < ApplicationRecord
  extend Devise::Models # Required for Devise Token Auth
  enum :usertype, { organizer: "organizer", customer: "customer" } # Define roles

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  include DeviseTokenAuth::Concerns::User


  has_many :events, foreign_key: "organizer_id",  dependent: :destroy
  has_many :bookings, foreign_key: "customer_id",  dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :usertype, presence: true
end
