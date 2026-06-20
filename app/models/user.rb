class User < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :habit_completions, through: :habits
  has_many :reminders, through: :habits
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements

  enum :role, { standard: "standard", admin: "admin" }, default: "standard"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, length: { maximum: 100 }, allow_blank: true
  validates :timezone, presence: true
end
