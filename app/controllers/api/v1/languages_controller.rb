module Api
  module V1
    
    class LanguagesController < Api::V1::ApiController

      # GET /languages
      # GET /languages.json
      def index
        @languages = Language.on_api_license(@api_license)
        render json: { languages: @languages.as_json }
      end

      # GET /languages/1
      # GET /languages/1.json
      def show
        @language = Language.find(params[:id])     
        render json: @language
      end

    end
  end
end