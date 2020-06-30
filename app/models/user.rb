class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :last_name, presence: true, length: {maximum: 10}
  validates :first_name, presence: true, length: {maximum: 10}
  validates :read_last_name, presence: true, length: {maximum: 20}, format: {with: /\A[\p{katakana}　ー－]+\z/, message: "は全角カタカナのみで入力してください", allow_blank: true}
  validates :read_first_name, presence: true, length: {maximum: 20}, format: {with: /\A[\p{katakana}　ー－]+\z/, message: "は全角カタカナのみで入力してください", allow_blank: true}
  validates :introduction, length: {maximum: 100}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :contacts, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy #自分からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy #相手からの通知

  # ユーザーをフォローする
  def follow(user_id)
  	follower.create(followed_id: user_id)
  end

  # ユーザーのフォローをはずす
  def unfollow(user_id)
  	follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrue
  def following?(user)
  	following_user.include?(user)
  end

  # フォロー通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 2])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end


  attachment :image
end
