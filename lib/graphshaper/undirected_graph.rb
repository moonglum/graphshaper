module Graphshaper
  class UndirectedGraph
    # Create a graph with a given number of vertices
    def initialize(number_of_vertices)
      @vertex_degrees = [0] * number_of_vertices
      @edges = Set.new
      @unconnected_vertices = Set.new (0...number_of_vertices).to_a
    end
    
    def UndirectedGraph.without_orphans_with_order_of(number_of_vertices)
      graph = self.new number_of_vertices
      
      while graph.number_of_orphans > 0
        a = rand(graph.order)
        while a == (b = rand(graph.order)); end
        
        graph.add_edge a, b
      end
      
      return graph
    end
    
    # the number of vertices
    def order
      @vertex_degrees.length
    end
    
    # the number of edges
    def size
      @edges.length
    end
    
    def add_vertex
      @vertex_degrees << @number_of_vertices
      @unconnected_vertices.add @number_of_vertices
    end
    
    def add_edge(first_vertex_id, second_vertex_id)
      if first_vertex_id == second_vertex_id
        raise "No Self-Referential Edge"
      elsif first_vertex_id >= order || second_vertex_id >= order
        raise "ID doesn't exist"
      else
        @unconnected_vertices.delete first_vertex_id
        @vertex_degrees[first_vertex_id] += 1
        @unconnected_vertices.delete second_vertex_id
        @vertex_degrees[second_vertex_id] += 1
        @edges << [first_vertex_id, second_vertex_id].sort
      end
    end
    
    def edge_between?(first_vertex_id, second_vertex_id)
      @edges.include? [first_vertex_id, second_vertex_id]
    end
    
    # The number of vertices without edges
    def number_of_orphans
      @unconnected_vertices.length
    end
    
    def vertex_degree_for(vertex_id)
      @vertex_degrees[vertex_id]
    end
    
    def degree_distribution
      degree_distribution = []
      @vertex_degrees.each do |vertex_degree|
        if degree_distribution[vertex_degree]
          degree_distribution[vertex_degree] += 1
        else
          degree_distribution[vertex_degree] = 1
        end
      end
      degree_distribution
    end
    
    def calculate_vertex_degree_for(vertex_id)
      @vertex_degrees[vertex_id]
    end
    
    def sum_of_all_degrees
      @edges.length * 2
    end
    
    def each_vertex_with_preferential_attachment(&block)
      if sum_of_all_degrees > 0
        preferential_attachments = @vertex_degrees.map { |degree| degree.round(1) / sum_of_all_degrees }
        vertex_id = 0
        preferential_attachments.each do |preferential_attachment|
          block.call vertex_id, preferential_attachment
          vertex_id += 1
        end
      end
    end

  end
end