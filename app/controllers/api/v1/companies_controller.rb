# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        n = params[:n].to_i
        filters = params[:filters].permit!.to_h

        if n <= 0
          render json: { error: 'Invalid value for n' }, status: :bad_request
          return
        end

        begin
          scraper_service = ScraperService.new(n:, filters:)
          csv_data = scraper_service.to_csv
          send_data csv_data, filename: 'y_combinator_companies.csv', type: 'text/csv'
        rescue StandardError => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end
end
