class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :collections
  has_many :games, :through => :collections

  has_many :ratings
  has_many :games, :through => :ratings

  def self.user_select
    user_select = [["All",-1]] + User.all.order(:surname).map{|user| ["#{user.first_name} #{user.surname}",user.id]}
  end

end
