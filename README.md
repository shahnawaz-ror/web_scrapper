#  Web Scraper API

## Overview
This Ruby on Rails application provides an API to scrape Y Combinator's publicly listed companies. The scraper can retrieve a specified number of companies with various filters and outputs the data in CSV format.

## Features
- Scrape company details from Y Combinator.
- Filter companies based on batch, industry, region, tag, company size, and boolean filters.
- Export scraped data to a CSV file.

## Requirements
- Ruby 3.x
- Rails 6.x or 7.x
- PostgreSQL or SQLite
- Chrome browser
- ChromeDriver
- Selenium WebDriver gem
- Nokogiri gem
- HTTParty gem

## Setup

### 1. Clone the repository

git clone https://github.com/shahnawaz-ror/web_scrapper.git
cd web_scrapper

### 2. Install dependencies

bundle install

### 4. Install ChromeDriver

- **MacOS:**
brew install chromedriver

- **Ubuntu:**
sudo apt-get install -y chromedriver

### Running the server

rails server

### API Endpoint
- **Endpoint:** `POST /api/v1/companies`
- **Description:** Scrape Y Combinator companies and get the data in CSV format.
- **Parameters:**
  - `n`: Number of companies to scrape.
  - `filters`: JSON object containing various filters for scraping.

#### Example Request

curl -X POST http://localhost:3000/api/v1/companies
-d '{"n": 10, "filters": {"batch": "W22", "industry": "Software"}}'
-H "Content-Type: application/json"

## Code Structure

### ScraperService
The `ScraperService` class is responsible for scraping the Y Combinator website. It uses Selenium WebDriver to navigate pages and Nokogiri to parse the HTML.

### API Controller
The `Api::V1::CompaniesController` handles the API requests. It initializes the scraper service, processes the request parameters, and sends the CSV file as a response.

### Routes
The API endpoint is defined in `config/routes.rb` under the `api/v1` namespace.

## Notes
- Ensure that the Chrome browser and ChromeDriver are installed and compatible with each other.
- Adjust the sleep time in the `ScraperService` if the page loading time varies.

