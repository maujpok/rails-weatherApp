require 'json'
require 'rest-client'

class City < ApplicationRecord

    self.inheritance_column = nil
    before_save     :to_lower_name
    validates       :name, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 40}
    validates       :key, presence: true

    BASIC_URL = "http://dataservice.accuweather.com"
    @apikey = ENV['API_KEY']

    class << self
        def get_key(name)
            url = "#{BASIC_URL}/locations/v1/cities/search?apikey=#{@apikey}&q=#{name}"
            response = RestClient.get(url) { |response, request, result| response }

            if response.length > 0
                json = JSON.parse response.to_s
                city_key = json[0]['Key']
            else
                @city.errors.full_messages.each do |msg|
                    flash[:danger] = msg
                end
            end
        end

        def get_today(key)
            url = "#{BASIC_URL}/forecasts/v1/daily/1day/#{key}?apikey=#{@apikey}"
            response = RestClient.get(url)
            json = JSON.parse response.to_s
        end

        def get_forecast(key)
            url = "#{BASIC_URL}/forecasts/v1/daily/5day/#{key}?apikey=#{@apikey}&details=true"
            response = RestClient.get (url)
            json = JSON.parse response.to_s
        end

        def get_city_image(name)
            url = "https://api.teleport.org/api/urban_areas/slug:#{name}/images/"
            response = RestClient.get (url) { |response, request, result| response }

            if response.code == 200
                json = JSON.parse response.to_s
                url_link = json['photos'][0]['image']['web']
            else
                url_link = "https://www.publicdomainpictures.net/pictures/280000/nahled/not-found-image-15383864787lu.jpg"
            end
        end
        
    end

    private
    def to_lower_name
        name.downcase!
    end
end