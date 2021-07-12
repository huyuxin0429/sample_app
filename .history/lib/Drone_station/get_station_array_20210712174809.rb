module GetStationArray
    @@file = File.open("#{Rails.root}/lib/Drone_station/Drone_station_location.csv")
    @@file_data = @@file.readlines.map(&:chomp)
    puts @@file_data
    byebug
    line = @@file_data.reada
    def new
        # byebug
        @@file_data.sample.split
    end
    # byebug
    @@file.close
end