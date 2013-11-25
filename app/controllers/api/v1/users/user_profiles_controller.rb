module Api
	module V1
		module Users

			class ProfilesController <  Api::V1::ApiController


				before_filter :identify_user, :read_user


				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.find( params[:id] )
				end

				# Returns all the profiles linked with the selected user
				def index
			    	if authorize_request(:profile, :read)
				        profiles = @selected_user.profiles
				        respond_to do | format |
				        	format.json { render json: profiles }
				    	end
					end
			    end

				def show
					authorize_request(:profile, :read, @selected_user) #returns if request is not authorized
					@profile = @selected_user.profiles.find(params[:id])
					respond_to do |format|
						format.json { render json:  { users: @profile.as_json }  }
					end
				end

				#recieves a json with the following format: "{ user_profiles:{ profile_id: ID } }"
				def create
					authorize_request(:profile, :create, @selected_user)
					@profile = Profile.find(params[:user_profiles][:profile_id])
					@selected_user.profiles << @profile

					respond_to do |format|
						if @profile.save
							format.json { render json: @profile, status: :created}
						else
							format.json { render json: @profile.errors.to_json, status: :unprocessable_entity }
						end
					end
				end

				def destroy
					authorize_request(:profile, :delete, @selected_user)

					@profile = @selected_user.profiles.find(id: params[:id])
					
					respond_to do |format|
						if @profile.destroy
							format.json { render json: @profile, status: :updated }
						else
							format.json { render json: @profile.errors, status: :unprocessable_entity }
						end
					end

				end  

			end 
		end
	end
end