module GetStationArray
    @@file = File.open("#{Rails.root}/lib/Drone_station/Drone_station_location.csv")
    @@file_data = @@file.readlines.map(&:chomp)
    puts @@file_data
    def new
        # byebug
        @@file_data.sample.split
    end
    # byebug
    @@file.close
end