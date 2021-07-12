module GetStationArray
    @@file = File.open("#{Rails.root}/lib/Drone_station/Drone_station_location.csv")
    @@file_data = @@file.readlines.map(&:chomp)
    puts @@file_data
    station_array = {}
    @@file_data.for_each { |line|
        line_data = line.split(",")
        if (line_data[0] != "ID") {
            station_array[line_data[0]] = {
                lat: line_data[1],
                lng: line_data[2]
            }
        }
    }
    byebug
    line = @@file_data.reada
    def new
        # byebug
        @@file_data.sample.split
    end
    # byebug
    @@file.close
end