module GraphModules
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
                @@station_hash[line_data[0].to_i] = {
                    lat: line_data[1].to_f,
                    lng: line_data[2].to_f
                }
            end
        }
        # byebug

        @@edge_data.each { |line|
            line_data = line.split(",")
            if (line_data[0] != "ID") 
                id = line_data[0].to_i
                line_connection = line_data[1..-1]
                line_connection = line_connection.map { |connection|
                    connection.to_i

                }
                @@edge_hash[id] = line_connection
            end
            # byebug

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


        #Path Generation stuff

        @@shortest_paths = Setting.shortest_paths
        @@next = Setting.next

        @@stations = Station.all.to_a.map{ |station| 
            station.provided_id
        }

        @@edges = Edge.all.to_a

        def path(src, dest)
            @@shortest_paths = Setting.shortest_paths
            @@next = Setting.next
            byebug
            if @@next[src][dest] == nil
                return []
            else
                path = [src]
                while src != dest 
                    src = @@next[src][dest]
                    path << src
                end
                return path
            end

        end

        def path_address(src, dest)
            num_path = path(src,dest)
            coord_path = num_path.map{ |num|
                Staion.find_by(provided_id: num).address
            }
            return coord_path
        end
        

        def all_pairs_shortest_paths
            generate_shortest_path_skeleton
            
            @@stations.each do |thru_v|
                @@stations.each do |src_v|
                    @@stations.each do |dest_v|
                        if @@shortest_paths[src_v][thru_v] + @@shortest_paths[thru_v][dest_v] < 
                            @@shortest_paths[src_v][dest_v]
                            @@shortest_paths[src_v][dest_v] = @@shortest_paths[src_v][thru_v] + @@shortest_paths[thru_v][dest_v] 
                            @@next[src_v][dest_v] = @@next[src_v][thru_v]
                        end
                    end
                end
            end
            Setting.shortest_paths = @@shortest_paths
            Setting.next = @@next

            @@shortest_paths
        end

        def generate_shortest_path_skeleton
            # @@shortest_paths = @@stations.inject({}) do |hash, src_v|
            #     @@next[src_v][src_v] = src_v
            #     hash[src_v] = @@stations.inject({}) do |inner_hash, dest_v|
            #         inner_hash[dest_v] = dest_v == src_v ? 0 : Float::INFINITY
            #         inner_hash
            #     end
            #     hash
            # end

            for src in @@stations do
                @@next[src] = []
                @@next[src][src] = src
                @@shortest_paths[src] = []
                for dest in @@stations do
                    @@shortest_paths[src][dest] = src == dest ? 0 : Float::INFINITY
                end
            end

            # @@shortest_paths = 


            # byebug

            @@edges.each do |edge|
                src, dest, cost = edge.provided_src_id, edge.provided_dest_id, edge.cost
                # byebug
                @@shortest_paths[src][dest] = cost
                @@next[src][dest] = dest
            end

        end
    end
end