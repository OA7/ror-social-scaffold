class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friend_requests
  has_many :pending_friend_requests, -> {where status: false}, class_name: 'FriendRequest', foreign_key: 'friend_id'


  def friends
    sent = FriendRequest.where(user_id: id, status: true).pluck(:friend_id)
    received = FriendRequest.where(friend_id: id, status: true).pluck(:user_id)

    friendship = sent + received

    User.where(id: friendship)
  end
end
