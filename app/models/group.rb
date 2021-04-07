class Group < ApplicationRecord
  belongs_to :round
  has_many :matches, dependent: :destroy
  has_many :affiliations, dependent: :destroy
  has_many :teams, through: :affiliations
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :round
end
