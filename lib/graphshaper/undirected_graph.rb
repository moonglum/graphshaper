module Graphshaper
  class UndirectedGraph
    # Create a graph with a given number of vertices
    def initialize(number_of_vertices)
      @number_of_vertices = number_of_vertices
      @edges = Set.new
      @unconnected_vertices = Set.new (0...number_of_vertices).to_a
    end
    
    # the number of vertices
    def order
      @number_of_vertices
    end
    
    # the number of edges
    def size
      @edges.length
    end
    
    def add_vertex
      @unconnected_vertices.add @number_of_vertices
      @number_of_vertices += 1
    end
    
    def add_edge(first_node_id, second_node_id)
      if first_node_id == second_node_id
        raise "No Self-Referential Edge"
      elsif first_node_id >= order || second_node_id >= order
        raise "ID doesn't exist"
      else
        @unconnected_vertices.delete first_node_id
        @unconnected_vertices.delete second_node_id
        @edges << [first_node_id, second_node_id].sort
      end
    end
    
    def edge_between?(first_node_id, second_node_id)
      @edges.include? [first_node_id, second_node_id]
    end
    
    # The number of vertices without edges
    def number_of_orphans
      @unconnected_vertices.length
    end
  end
end