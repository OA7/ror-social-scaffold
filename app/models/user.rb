class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :pending_friendships, -> { where(status: -1) }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :incoming_friendships, -> { where(status: -1) }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :incoming_friendships, source: :user

  def friends
    friends_array = []
    friendships.map { |friendship| friends_array << friendship.friend if friendship.status == 1 }
    inverse_friendships.map { |friendship| friends_array << friendship.user if friendship.status == 1 }
    friends_array
  end

  def confirm_friend(user)
    friendshipz = inverse_friendships.find { |friendship| friendship.user == user if friendship.status == -1 }
    friendshipz.status = 1
    friendshipz.save
  end


  def friend?(user)
    friends.include?(user)
  end

  def reject_friend_request(user)
    friendshipz = inverse_friendships.find { |friendship| friendship.user == user if friendship.status == -1 }
    friendshipz.status = 0
    friendshipz.save
  end

  def send_friend_request(user, friend)
    new_friend = user.friendships.new(friend_id: friend.id, status: -1)
    new_friend.save
  end
end
