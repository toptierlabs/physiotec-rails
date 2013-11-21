module Api
  module V1
    class UsersController < Api::V1::ApiController
      # @current_user will hold the identified user
      before_filter :identify_user, :except=>[:login]

      # GET /users
      # GET /users.json
      def index
        @users = User.all

        respond_to do |format|
          format.json { render json:  { users: @users.as_json }  }
        end
      end

      # GET /users/1
      # GET /users/1.json
      def show
        @user = User.where(id: params[:id]).first

        respond_to do |format|
          if @user.nil?
            format.json { render json: { :error => "User not found." }, status: :unprocessable_entity }
          else
            format.json { render json: @user }
          end
        end
      end


      #POST /users/login
      def login
        #search the user by email
        user = User.find_by_email(params[:email])     
        #check if the recieved password matches the user password
        if user !=nil and user.valid_password?(params[:password])
          #creates a session token
          session_token = user.new_session_token
          respond_to do |format|
            format.json { render json: {token: session_token, user_id: user.id}, status: :created}
          end
        else
          render json: {:error => "401"}, status: 401
        end
      end


      # POST /users
      # POST /users.json
      #The content of the request must have a json with the following format:
      # { email: String,
      #   first_name: String,
      #   last_name: String,
      #   profiles: [String] }
      def create
        error = !(@current_user.can? :user, :create)
        #if user can create another user
        if !error
          #new user from parameters
          user = User.new(params[:user].except(:user_profiles).except(:profiles))
          user.api_license_id = @api_license.id

          #profile assignations
          params[:user][:user_profiles].each do | profile_name |
            profile = Profile.find_by_name(profile_name)

            error = profile.nil?
            puts error
            #current user can assign ingresed profile
            puts @current_user.to_json
            error = !@current_user.can?(:profile, :assign, :scopes=>[profile.name.parameterize.underscore.to_sym]) unless error
            puts !@current_user.can?(:profile, :assign, :scopes=>[:author])
            puts error
            break if error
            user.profiles << profile
          end
          error = !user.save unless error
        end

        respond_to do |format|
          if !error
            format.json { render json: user, status: :created }
          else
            #if user == nil then the current user does not have sufficient privileges
            response_error = response_error || { :error => "Can not complete the operation because you do not have sufficient privileges." }
            format.json { render json: response_error, status: :unprocessable_entity }
          end
        end
      end

      # PUT /users/1
      # PUT /users/1.json
      def update
        @user = User.find(params[:id])

        respond_to do |format|
          if @user.update_attributes(params[:user])
            format.json { head :no_content }
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /users/1
      # DELETE /users/1.jsonº
      def destroy
        @user = User.find(params[:id])
        @user.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end
    end
  end
end
