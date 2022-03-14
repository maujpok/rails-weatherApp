module CitiesHelper

    def data
        array = [20,30, "today is fine"]
    end

    def cincodias
        array = [20,30, 40,50, "today is fine"]
    end

    def image(name)
        unless !name.match(/\s/)
            name = name.gsub(' ', '-')
        end
        res = City.get_city_image(name)
    end

    # def get_icon(num)
    #     data = `/assets/#{num}.png`
    #     res = data.to_s
    # end


    # def temp(key)
    #     res = City.get_today(key)
    #     temps = [
    #         (( res['DailyForecasts'][0]['Temperature']['Minimum']['Value'] - 32 ) * 5/9).round,
    #         (( res['DailyForecasts'][0]['Temperature']['Maximum']['Value'] - 32 ) * 5/9).round,
    #         res['Headline']['Text']
    #     ]
    # end

    # def forecast(key)
    #     res = City.get_forecast(key)
    # end

end