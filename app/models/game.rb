class Game < ApplicationRecord

  has_many :collections
  has_many :users, :through => :collections

  scope :by_user,->(search_id){joins(:collections).where(collections:{user_id: search_id})}
  
end
