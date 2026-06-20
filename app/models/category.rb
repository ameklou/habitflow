class Category < ApplicationRecord
  belongs_to :user
  has_many :habits, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 80 }
  validates :color, format: { with: /\A#[0-9a-fA-F]{6}\z/ }, allow_blank: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
