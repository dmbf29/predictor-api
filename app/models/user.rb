class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  has_many :memberships, dependent: :destroy
  has_many :competitions, through: :leagues
  has_many :predictions, dependent: :destroy
  has_many :matches, through: :predictions
  validates :name, presence: true
  validates :timezone, presence: true

  def leagues
    # this includes creator or league and members
    League.includes(:memberships).where(memberships: { user: self }).or(League.where(user: self))
  end
end
