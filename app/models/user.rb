class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable # :confirmable
  include DeviseTokenAuth::Concerns::User
  has_many :memberships, dependent: :destroy
  has_many :competitions, through: :leagues
  has_many :predictions, dependent: :destroy
  has_many :matches, through: :predictions

  def leagues
    # this includes creator or league and members
    League.includes(:memberships).where(memberships: { user: self }).or(League.where(user: self))
  end
end
