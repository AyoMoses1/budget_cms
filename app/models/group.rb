class Group < ApplicationRecord
  belongs_to :user
  has_many :expenses_groups, dependent: :destroy
  has_many :expenses, through: :expenses_groups
  validates :name, presence: true
  has_one_attached :icon
end
