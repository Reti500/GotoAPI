class User < ActiveRecord::Base
  include Tokenable

  authenticates_with_sorcery!

  belongs_to :role
  has_many :social_relations

  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true
end
