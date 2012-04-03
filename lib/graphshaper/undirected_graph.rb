require "set"

module Graphshaper
  
  # A Graph is undirected when its edges do not have a direction.
  class UndirectedGraph
    
    # Create a graph with a given number of vertices and no edges.
    # 
    # @param [Integer] number_of_vertices The number of vertices that the generated graph should have
    # @param [Hash] options_hash The options to create an undirected graph
    # @option options_hash [IO] :edge_creation_logger An IO object that should log every edge creation in the graph (default: no logging)
    def initialize(number_of_vertices, options_hash = {})
      @vertex_degrees = [0] * number_of_vertices
      @edges = Set.new
      @unconnected_vertices = Set.new (0...number_of_vertices).to_a
      
      if options_hash.has_key? :edge_creation_logger
        @edge_creation_logger = options_hash[:edge_creation_logger]
      end
    end
    
    # Create a graph with a given number of vertices. Then it adds random edges until the graph doesn't contain any orphans (vertices without edges).
    # 
    # @param [Integer] number_of_vertices The number of vertices that the generated graph should have
    # @param [Hash] options_hash The options to create an undirected graph
    # @option options_hash [IO] :edge_creation_logger An IO object that should log every edge creation in the graph (default: no logging)
    # @return [UndirectedGraph] The generated graph.
    def UndirectedGraph.without_orphans_with_order_of(number_of_vertices, options_hash = {})
      graph = self.new number_of_vertices, options_hash
      
      while graph.number_of_orphans > 0
        a = rand(graph.order)
        while a == (b = rand(graph.order)); end
        
        graph.add_edge a, b
      end
      
      return graph
    end
    
    # The number of vertices.
    #
    # @return [Integer] Number of vertices.
    def order
      @vertex_degrees.length
    end
    
    # The number of edges.
    # 
    # @return [Integer] Number of edges.
    def size
      @edges.length
    end
    
    # Add a new vertex to the graph.
    # If you call it with a block {|preferential_attachment| ... }, the block will be called for every existing vertex: An edge from the new vertex to this vertex will be created if and only if the block returns true.
    # @yield [preferential_attachment] The block that tests if the edge should be added.
    #
    # @yieldparam [Float] preferential_attachment The preferential attachment of the existing vertex
    # @yieldreturn [Boolean] Should the edge be added?
    # 
    # @return [Integer] ID of the newly created vertex.
    def add_vertex(&block)
      @vertex_degrees << 0
      
      new_vertex_id = @vertex_degrees.length - 1
      if block_given? 
        each_vertex_with_preferential_attachment do |vertex_id, preferential_attachment|
          add_edge new_vertex_id, vertex_id if block.call(preferential_attachment)
        end
      end
      
      new_vertex_id
    end
    
    # Add a new edge to the graph between two existing nodes.
    # 
    # @param [Integer] first_vertex_id
    # @param [Integer] second_vertex_id
    # @raise [RuntimeError] The method throws a RuntimeError if you try to add a self-referential edge or an edge with a non-existing vertex.
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
        
        @edge_creation_logger << "#{first_vertex_id},#{second_vertex_id}\n" if @edge_creation_logger
      end
    end
    
    # Tests, if an edge between the two vertices exists.
    #
    # @param [Integer] first_vertex_id
    # @param [Integer] second_vertex_id
    # @return [Boolean] Does the vertex exist?
    def edge_between?(first_vertex_id, second_vertex_id)
      @edges.include? [first_vertex_id, second_vertex_id]
    end
    
    # The number of vertices without edges.
    #
    # @return [Integer] Number of vertices without edges.
    def number_of_orphans
      @unconnected_vertices.length
    end
    
    # Return the vertex degree for the node with the given ID.
    #
    # @param [Integer] vertex_id
    # @return [Integer] Degree of the given vertex
    def vertex_degree_for(vertex_id)
      @vertex_degrees[vertex_id]
    end
    
    # Calculates the distribution of degrees in the graph. The value at the n-th position of the returned array is the number of vertices with n edges.
    #
    # @return [Array<Integer>] The degree distribution as an array of Integers.
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
    
    # Return the vertex degree for the node with the given ID.
    #
    # @param [Integer] vertex_id
    # @return [Integer] Degree of the given vertex
    def calculate_vertex_degree_for(vertex_id)
      @vertex_degrees[vertex_id]
    end
    
    # Return the sum of all degrees.
    #
    # @return [Integer] Sum of all degrees
    def sum_of_all_degrees
      @edges.length * 2
    end
    
    # Iterate over all vertices of the graph. Call it with a block {|vertex_id, preferential_attachment| ... }.
    # 
    # @yield [vertex_id, preferential_attachment] The block that tests if the edge should be added.
    # @yieldparam [Integer] vertex_id The preferential attachment of the existing vertex
    # @yieldparam [Float] preferential_attachment The preferential attachment of the existing vertex
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