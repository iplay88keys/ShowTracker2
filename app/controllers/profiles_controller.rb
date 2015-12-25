class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @apikeys = ApiKey.where(user_id: current_user.id)
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    @profile.save
 
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    if (params[:email])
        unless @profile.user.update(:email => params[:email]) 
            redirect_to :back, alert: 'Invalid email'
            return
        end
    end
    if(params[:update_password])
        if(current_user.valid_password? params[:current_password])
            if(params[:password] == params[:password_confirmation]) 
                unless @profile.user.update(:password => params[:password], :password_confirmation => params[:password_confirmation])
                    redirect_to :back, alert: 'Please provide a valid password, length greater than 8'
                    return
                end
            else 
                redirect_to :back, alert: 'Passwords do not match'
                return
            end
        else 
            redirect_to :back, alert: 'Invalid current password provided'
            return
        end
    end
    
    sign_in @profile.user, :bypass => true
    
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_key
    key = ApiKey.new
    key.user_id = params[:user_id]
    key.expires_at = Time.now + 3.month
    key.save!
    redirect_to profile_path(params[:user_id])
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  #def destroy
  #  @profile.destroy
  #  respond_to do |format|
  #    format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find_by_id(params[:id])
      if @profile == nil || @profile.user_id != current_user.id
        flash[:alert] = "Can't access that profile"
        redirect_to :home
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:name, :avatar)
    end
end
