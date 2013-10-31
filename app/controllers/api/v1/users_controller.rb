module Api
  module V1
    class UsersController < Api::V1::ApiController
      # GET /users
      # GET /users.json
      def index
        @users = User.all

        respond_to do |format|
          format.json { render json: @users }
        end
      end

      # GET /users/1
      # GET /users/1.json
      def show
        @user = User.find(params[:id])

        respond_to do |format|
          format.json { render json: @user }
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
      def create
        @user = User.new(params[:user])

        respond_to do |format|
          if @user.save
            format.json { render json: @user, status: :created, location: @user }
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
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
      # DELETE /users/1.json
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
