class SocialRelation < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :access_token, presence: true
  validates :social_id, presence: true
  
  validates :name, uniqueness: true
end
