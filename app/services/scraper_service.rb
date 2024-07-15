# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'csv'
require 'selenium-webdriver'

class ScraperService
  BASE_URL = 'https://www.ycombinator.com/companies'

  def initialize(n:, filters:)
    @n = n
    @filters = filters
  end

  def scrape
    companies = []
    page = 1

    driver = Selenium::WebDriver.for :chrome

    while companies.size < @n
      driver.navigate.to "#{BASE_URL}?page=#{page}&#{filters_query}"
      sleep 3 # Allow time for the page to load
      document = Nokogiri::HTML(driver.page_source)
      company_elements = document.css('a._company_86jzd_338')

      company_elements.each do |element|
        break if companies.size >= @n

        company_name = element.css('span._coName_86jzd_453').text.strip
        company_location = element.css('span._coLocation_86jzd_469').text.strip
        short_description = element.css('span._coDescription_86jzd_478').text.strip
        yc_batch = element.css('span._pill_86jzd_33').text.strip

        # Get the company URL to scrape the second page
        company_url = "https://www.ycombinator.com#{element['href']}"
        company_response = HTTParty.get(company_url)
        company_document = Nokogiri::HTML(company_response.body)

        website = company_document.css('a[target="_blank"]').map do |link|
                    link['href']
                  end.find { |url| url.include?('http') } || ''
        founder_names = company_document.css('div.space-y-5 div.flex-grow h3.text-lg.font-bold').map(&:text).map(&:strip)
        linkedin_urls = company_document.css('a.inline-block.w-5.h-5.bg-contain.bg-image-linkedin').map do |link|
                          link['href']
                        end.find { |url| url.include?('linkedin.com/company') } || ''

        companies << {
          company_name:,
          company_location:,
          short_description:,
          yc_batch:,
          website:,
          founder_names:,
          linkedin_urls:
        }
      end

      break if companies.size >= @n

      page += 1
    end

    driver.quit
    companies
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Company Name', 'Location', 'Short Description', 'YC Batch', 'Website', 'Founder Names', 'LinkedIn URLs']

      scrape.each do |company|
        csv << [
          company[:company_name],
          company[:company_location],
          company[:short_description],
          company[:yc_batch],
          company[:website],
          company[:founder_names].join(', '),
          company[:linkedin_urls]
        ]
      end
    end
  end

  private

  def filters_query
    @filters.map { |key, value| "#{key}=#{value}" }.join('&')
  end
end
