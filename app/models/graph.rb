class Graph < ApplicationRecord
    attr_reader :vertices, :edges

    @@shortest_paths = nil
    @@next = nil

    def initialize(vertices, edges)
        @vertices = vertices
        @edges = edges
    end

    def all_pairs_shortest_paths
        generate_shortest_path_skeleton
        
        vertices.each do |thru_v|
            vertices.each do |src_v|
                vertices.each do |dest_v|
                    if @@shortest_paths[src_v][thru_v] + @@shortest_paths[thru_v][dest_v] < 
                        @@shortest_paths[src_v][dest_v]
                        @@shortest_paths[src_v][dest_v] = @@shortest_paths[src_v][thru_v] + @@shortest_paths[thru_v][dest_v] 
                        @@next[src_v][dest_v] = @@next[src_v][thru_v]
                    end
                end
            end
        end

        @@shortest_paths
    end

    def generate_shortest_path_skeleton
        @@shortest_paths = vertices.inject({}) do |hash, src_v|
            next[src_v][src_v] = src_v
            hash[src_v] = vertices.inject({}) do |inner_hash, dest_v|
                inner_hash[dest_v] = dest_v == src_v ? 0 : Float::INFINITY
                inner_hash
            end
            hash
        end

        edges.each do |edge|
            src, dest, cost = edge.src, edge.dest, edge.cost

            @@shortest_paths[src][dest] = cost
            @@next[src][dest] = dest
        end

    end
end
