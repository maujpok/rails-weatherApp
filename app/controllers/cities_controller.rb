class CitiesController < ApplicationController

    def index
      @city = City.new
      @cities = City.all
      @temp = {}
      
      @cities.each do |city|
        get_data = City.get_today(city.key)
        res = {
          min: (( get_data['DailyForecasts'][0]['Temperature']['Minimum']['Value'] - 32 ) * 5/9).round,
          max: (( get_data['DailyForecasts'][0]['Temperature']['Maximum']['Value'] - 32 ) * 5/9).round,
          text: get_data['Headline']['Text']
        }
        @temp[city.key] = (res)
      end
      puts @temp
    end
  
    def create
      @city = City.new(city_params)
      key = City.get_key(@city.name)
      @city.key = key
  
      respond_to do |format|
        if @result = @city.save
          format.html { redirect_to root_url }
          format.js
        else
          format.html {
            @city.errors.full_messages.each do |msg|
              flash[:danger] = msg
            end
            redirect_to root_url
          }
          format.js
        end
      end
  
    end
  
    def destroy
  
      @city = City.find(params[:id])
  
      respond_to do |format|
        if @result = @city.destroy()
          format.html { redirect_to root_url }
          format.js
        else
          format.html {
            @city.errors.full_messages.each do |msg|
              flash[:danger] = msg
            end
            redirect_to root_url
          }
          format.js
        end
      end
      
    end
  
    def forecast
      @city = City.find(params[:id])
      @forecast = City.get_forecast(@city.key)
      @filtered_data = []
      @max_temps = []
      @days_list = []
      
  
      @forecast['DailyForecasts'].each do |day|
        day = {
          date: day['Date'].scan(/.{1,10}/)[0],
          minimum: (( day['Temperature']['Minimum']['Value'] - 32 ) * 5/9).round,
          minimum_phrase: day['RealFeelTemperatureShade']['Minimum']['Phrase'],
          maximum: (( day['Temperature']['Maximum']['Value'] - 32 ) * 5/9).round,
          maximum_phrase: day['RealFeelTemperatureShade']['Maximum']['Phrase'],
          phrase: day['Day']['LongPhrase'],
          precipitacion_probability: day['Day']['PrecipitationProbability'],
          nubosity: day['Day']['CloudCover'],
          icon: day['Day']['Icon']
        }
        @filtered_data.push(day)
        @max_temps.push({name: day[:date], data: day[:maximum]})
        @days_list.push(day[:date])
      end
  
  
  
      puts "prueba"
      puts @filtered_data
      puts "---------------------------------------------------------------"
      puts @max_temps
      puts "---------------------------------------------------------------"
      puts @days_list
      puts "end"
  
    end
  
    def completed_tasks
      render json: Task.group_by_day(:completed_at).count
    end
  
    private
      def city_params
        params.require(:city).permit(:name)
      end
    
  end