module UserRoleConstraint
  class Cashier
    def self.matches?(request)
      current_user(request)&.cashier?
    end

    def self.current_user(request)
      User.find_by(id: request.session[:user_id])
    end
  end

  class Manager
    def self.matches?(request)
      user = current_user(request)
      user && (user.manager? || user.owner?)
    end

    def self.current_user(request)
      User.find_by(id: request.session[:user_id])
    end
  end
end
