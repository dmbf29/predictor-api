class Leaderboard < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  validates :name, presence: true
  has_secure_token :password

  def users
    User.includes(:memberships).where(memberships: { leaderboard: self }).or(User.where(id: user))
  end

  def leave(current_user)
    if user == current_user
      # remove if empty OR transfer
      memberships.any? ? transfer_ownership : destroy
    elsif (membership = memberships.find_by(user: current_user))
      # remove membership if just a regular member
      membership.destroy
    end
  end

  def transfer_ownership
    membership = memberships.first
    membership.destroy
    self.user = membership.user
    save
  end
end
