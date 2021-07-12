module GetStationHash
    class << self
        @@file = File.open("#{Rails.root}/lib/Drone_station/Drone_station_location.csv")
        @@file_data = @@file.readlines.map(&:chomp)
        puts @@file_data
        @@station_hash = {}
        @@file_data.each { |line|
            line_data = line.split(",")
            if (line_data[0] != "ID") 
                station_hash[line_data[0]] = {
                    lat: line_data[1],
                    lng: line_data[2]
                }
            end
        }
        
        def getHash
            # byebug
            @@station_hash
        end
        # byebug
        @@file.close
    end
end