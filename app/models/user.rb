class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profileimage

  has_many :texts, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :bookmarks, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  #has_many :mybookmarktexts, through: :bookmarks, source: :text
  #アソシエーションについて、現状では理解ができなくなったときにもうちょっとわかりやすいアソシエーションにできるかも、、
  #以下、記事のurl
  #https://sakaishun.com/2021/03/20/classname-source/

   validates :name, presence: true, length: {maximum: 16}

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end
end
