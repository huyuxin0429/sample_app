module GetStationHash
    class << self
        @@file = File.open("#{Rails.root}/lib/Drone_station/Drone_station_location.csv")
        @@edge_file = File.open("#{Rails.root}/lib/Drone_station/station_connections.csv")
        @@file_data = @@file.readlines.map(&:chomp)
        @@edge_data = @@edge_file.readlines.map(&:chomp)
        # puts @@file_data
        @@edge_hash = {}
        @@station_hash = {}
        @@file_data.each { |line|
            line_data = line.split(",")
            if (line_data[0] != "ID") 
                @@station_hash[line_data[0]] = {
                    lat: line_data[1],
                    lng: line_data[2]
                }
            end
        }

        @@edge_data.each { |line|
            line_data = line.split(",")
            if (line_data[0] != "ID") 
                connected_to = line_data[1].split(",")
                connected_to.map { |connection|
                    connection.strip.to_i

                }
                @@edge_hash[line_data[0]] = connected_to
            end
            byebug

        }
        
        def getStationHash
            # byebug
            @@station_hash
        end

        def getEdgeHash
            # byebug
            @@edge_hash
        end
        # byebug
        @@file.close
    end
end