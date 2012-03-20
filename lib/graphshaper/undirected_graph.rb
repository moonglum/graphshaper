module Graphshaper
  class UndirectedGraph
    # Create a graph with a given number of vertices
    def initialize(number_of_vertices)
      @number_of_vertices = number_of_vertices
      @edges = Set.new
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
      @number_of_vertices += 1
    end
    
    def add_edge(first_node_id, second_node_id)
      if first_node_id < order && second_node_id < order
        @edges << [first_node_id, second_node_id].sort
      else
        raise "ID doesn't exist"
      end
    end
    
    def connected?(first_node_id, second_node_id)
      @edges.include? [first_node_id, second_node_id]
    end
  end
end