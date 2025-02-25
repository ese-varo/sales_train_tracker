class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to root_path, notice: "Sesion iniciada correctamente!"
      else
        redirect_to login_path, alert: "Tu cuenta esta inactiva. Por favor contacta a tu manager."
      end
    else
      flash.now[:alert] = "Password o email invalido."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Sesion terminada correctamente!"
  end
end
