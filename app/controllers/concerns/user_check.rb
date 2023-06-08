module UserCheck
    def self.user_check(current_user)
        current_user ? current_user.id : 0
    end
end
