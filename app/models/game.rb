class Game < ApplicationRecord

  has_many :collections
  has_many :users, :through => :collections

  has_many :ratings
  has_many :users, :through => :ratings

  scope :by_user,->(search_id){joins(:collections).where(collections:{user_id: search_id}) if search_id.to_i > -1}
  scope :game_search,->(search_string){where('name LIKE ?', "%#{search_string}%")}
  scope :play_time,->(min,max,total){where("playing_time >= ? AND playing_time <= ? AND playing_time <= ?", min.to_f, max.to_f, total.to_f)}
  scope :by_weight,->(min,max){where("weight >= ? AND weight <= ?", min.to_f, max.to_f)}
  scope :by_players,->(min,max,rec = 0){rec == "1"? where("max_rec_players >= ? AND min_rec_players <= ?", min.to_f, max.to_f) : where("max_players >= ? AND min_players <= ?", min.to_f, max.to_f) }

  

  
end
