class Group < ApplicationRecord

  validates :name, presence:true
  validates :location, presence:true
  validates :location, length: {maximum: 500 }
  validates :name, length: { maximum: 50 }

  has_many :memberships
  has_many :users, :through => :memberships

  scope :by_user,->(search_id){joins(:memberships).where(memberships:{user_id: search_id}) if search_id.to_i > -1}
  scope :group_search,->(search_string){where('name LIKE ?', "%#{search_string}%")}

  def latitude_require
    errors.add(:base, 'Please select a location from the autocomplete. Group locations can be as broad as you like and do not require a street address') unless latitude.present?
  end

  def get_membership(user)
    member = memberships.where(user_id: user.id).first
  end

  def check_groups_shown(user)
    memberships.any? {|member| member.user_id == user.id} 
  end

  def admin_status(user)
    if (membership = memberships.where(user_id: user.id).first)
      puts "USER ID #{membership[:user_id]}"
      membership[:admin]
    else
      return false
    end
  end

  def member_count
    member_count = memberships.count
  end

  def admin_status(user)
    if (membership = memberships.where(user_id: user).first)
      puts "USER ID #{membership[:user_id]}"
      membership[:admin]
    else
      return false
    end
  end

  def get_membership(user)
    pp memberships.where(user_id: user).first
    member = memberships.where(user_id: user).first
  end

end
