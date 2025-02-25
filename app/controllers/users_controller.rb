class UsersController < ApplicationController
  before_action :authorize_manager!
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = current_user.organization.users.order(:name)
  end

  def show
  end

  def new
    @user = User.new
    @locations = available_locations
  end

  def create
    @user = User.new(user_params)
    @user.organization_id = current_user.organization_id

    # Only owners can create managers
    if @user.manager? && !current_user.owner?
      redirect_to users_path, alert: "Solo los propietarios pueden crear cuentas para managers."
      return
    end

    # Only owners can create users for any location
    if current_user.manager? && @user.location_id != current_user.location_id
      redirect_to users_path, alert: "Solo puedes crear usuarios para tu sucursal."
      return
    end

    if @user.save
      redirect_to @user, notice: 'Usuario creado correctamente.'
    else
      @locations = available_locations
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @locations = available_locations

    # Authorization checks
    unless can_edit_user?
      redirect_to users_path, alert: 'No tienes permisos suficientes para editar este usuario.'
    end
  end

  def update
    # Authorization checks again in case of tampering
    unless can_edit_user?
      redirect_to users_path, alert: 'No tienes permisos suficientes para editar este usuario.'
      return
    end

    # Only owners can promote to manager
    if user_params[:role] == "manager" && !current_user.owner?
      redirect_to @user, alert: 'Solo los propietarios pueden cambiar el rol de los usuarios a gerentes.'
      return
    end

    if @user.update(user_params)
      redirect_to @user, notice: 'Usuario actualizado correctamente.'
    else
      @locations = available_locations
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(params[:id])

      # Make sure user belongs to same organization
      unless @user.organization_id == current_user.organization_id
        redirect_to users_path, alert: 'Usuario no encontrado.'
      end
    end

    def user_params
      if current_user.owner?
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :active, :location_id)
      else
        # Managers can only edit basic info and active status, not roles
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :active)
      end
    end

    def available_locations
      if current_user.owner?
        current_user.organization.locations.where(active: true)
      else
        Location.where(id: current_user.location_id, active: true)
      end
    end

    def can_edit_user?
      return true if current_user.owner?
      return current_user.manager? && @user.location_id == current_user.location_id && !@user.manager?
    end
end
