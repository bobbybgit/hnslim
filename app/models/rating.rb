class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :game

  scope :by_user,->(search_id){where(user_id: search_id)}

  def self.rating_values
    [["Not Rated",0],["Veto",1],["Avoid",2],["Will Play",3],["Content",4],["Curious",5],["Keen",6],["Excited",7]]
  end

  def self.rating_reverse(rating)
    rating_values.assoc(rating[1]) if rating.present?
  end

  def self.translate_rating(rating)
    key = [[1,-20],[2,-5],[3,0],[4, 1],[5, 2],[6, 4],[7, 8],[0,0]]
    key.each do |score|
      return score[1] if rating == score[0]
    end
  end

end
