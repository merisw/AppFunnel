class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_profile, only: [:show, :edit, :update, :destroy]

  def index
    @profiles = Profile.all
  end

  def new

    if Profile.where(:user_id => current_user.id).exists?
      # binding.pry
      redirect_to show_profile_path
    else
      # binding.pry
      @profile = Profile.new
    end
  end

  def create
    @profile = Profile.create(profile_params)
    @profile.user = current_user
    if @profile.save
      flash[:notice] = "Your profile has been created."
      redirect_to @profile
    else
      flash[:alert] = "Your profile hasn't been created."
      render action: "new"
    end
  end

  def show
    @display_attributes = @profile.attributes
    excluded_attributes = ["user_id", "id", "created_at", "updated_at"]
    @display_attributes.delete_if {|key| excluded_attributes.include? key }
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      flash[:notice] = "Your profile has been updated."
      redirect_to @profile
    else
      flash[:alert] = "Your profile hasn't been updated."
      render action: "edit"
    end
  end

  def destroy
    @profile.destroy
    flash[:notice] = "Your profile has been deleted!"
    redirect_to profiles_path
  end

  private
    def profile_params
      params.require(:profile).permit(
        :first_name, :last_name, :email,
        :phone_number, :city, :state, :gender )
    end

    def find_profile
      @profile = Profile.find_by_user_id(current_user)
    rescue ActiveRecord::RecordNotFound
      redirect_to
    end

    def authorize_admin!
      authenticate_user!
      unless current_user.admin?
        flash[:alert] = "You need permission to do that."
        redirect_to root_path
      end
    end

end
