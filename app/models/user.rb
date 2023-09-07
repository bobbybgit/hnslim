class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :first_name
  validates_presence_of :surname

  has_many :collections
  has_many :games, :through => :collections

  has_many :ratings
  has_many :games, :through => :ratings

  has_many :memberships
  has_many :groups, :through => :memberships

  scope :members, -> (group){joins(:groups).where(groups:{id: group})}

  def member?(group)
    groups.exists?(group.id)
  end

  def self.user_select
    user_select = [["All",-1]] + User.all.order(:surname).map{|user| ["#{user.first_name} #{user.surname}",user.id]}
  end

  def self.group_user_select(group = 0, user_id)
    group < 1 ? [["All",-1]] + User.all.map{|user| ["#{user.first_name} #{user.surname}",user.id]} : [["All",-1]] + User.joins(:memberships).where(memberships:{group_id: group}).map{|user| ["#{user.first_name} #{user.surname}",user.id]}
  end

end
