require "set"

module Graphshaper
  
  # A Graph is undirected when its edges do not have a direction.
  class UndirectedGraph
    
    # Create a graph with a given number of vertices and no edges.
    # 
    # @param [Integer] number_of_vertices The number of vertices that the generated graph should have
    # @param [Hash] options_hash The options to create an undirected graph
    # @option options_hash [Array<Object>] :adapters An array of adapters you want to use
    def initialize(number_of_vertices, options_hash = {})
      @adapters = options_hash[:adapters] if options_hash.has_key? :adapters

      @vertex_degrees = []
      @unconnected_vertices = Set.new
      
      number_of_vertices.times { add_vertex }
      @edges = Set.new
    end
    
    # Create a graph with a given number of vertices. Then it adds random edges until the graph doesn't contain any orphans (vertices without edges).
    # 
    # @param [Integer] number_of_vertices The number of vertices that the generated graph should have
    # @param [Hash] options_hash The options to create an undirected graph
    # @return [UndirectedGraph] The generated graph.
    def UndirectedGraph.without_orphans_with_order_of(number_of_vertices)
      graph = self.new number_of_vertices
      
      while graph.number_of_orphans > 0
        vertex_orphan = graph.orphans.shuffle.first
        while vertex_orphan == (random_vertex = rand(graph.order)); end
        
        graph.add_edge vertex_orphan, random_vertex
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
      new_vertex_id = @vertex_degrees.length
      
      @vertex_degrees << 0
      @unconnected_vertices << new_vertex_id
      
      unless @adapters.nil?
        @adapters.each do |adapter|
          adapter.add_vertex new_vertex_id
        end
      end
      
      if block_given? 
        each_vertex_with_preferential_attachment do |vertex_id, preferential_attachment|
          add_edge new_vertex_id, vertex_id if block.call(preferential_attachment)
        end
      end
      
      new_vertex_id
    end
    
    # Add a new edge to the graph between two existing vertices.
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
        
        unless @adapters.nil?
          @adapters.each do |adapter|
            adapter.add_edge @edges.length - 1, first_vertex_id, second_vertex_id
          end
        end
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
      @unconnected_vertices.to_a.length
    end
    
    # The vertices without edges as an array.
    #
    # @return [Array<Integer>] IDs of the Vertices without edges.
    def orphans
      @unconnected_vertices.to_a
    end
    
    # Return the vertex degree for the vertex with the given ID.
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