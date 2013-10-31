module Api
  module V1
    class LicensesController < Api::V1::ApiController
      before_filter :identify_user

      # GET /licenses
      # GET /licenses.json
      def index
        @licenses = License.all

        respond_to do |format|
          format.json { render json: @licenses }
        end
      end

      # GET /licenses/1
      # GET /licenses/1.json
      def show
        @license = License.find(params[:id])

        respond_to do |format|
          format.json { render json: @license }
        end
      end


      # POST /licenses
      # POST /licenses.json
      def create
        @license = License.new(params[:license])

        respond_to do |format|
          if @license.save
            format.json { render json: @license, status: :created, location: @license }
          else
            format.json { render json: @license.errors, status: :unprocessable_entity }
          end
        end
      end

      # PUT /licenses/1
      # PUT /licenses/1.json
      def update
        @license = License.find(params[:id])

        respond_to do |format|
          if @license.update_attributes(params[:license])
            format.json { head :no_content }
          else
            format.json { render json: @license.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /licenses/1
      # DELETE /licenses/1.json
      def destroy
        @license = License.find(params[:id])
        @license.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end
    end
  end
end
