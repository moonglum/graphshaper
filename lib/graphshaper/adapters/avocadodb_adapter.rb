require "httparty"

module Graphshaper
  class ArangoDbAdapter
    include HTTParty
    
    base_uri 'localhost:8529'
    format :json
  
    def initialize(vertex_collection_name, edge_collection_name)
      @vertex_collection_name = vertex_collection_name
      @edge_collection_name = edge_collection_name
      @vertex_matching = []
      @edge_matching = []
      
      [@vertex_collection_name, @edge_collection_name].each { |collection| drop_and_create_collection collection}
    end
    
    def add_vertex(id)
      cmd = "/document?collection=#{@vertex_collection_name}"
    	body = "{ \"id\" : \"#{id}\" }"
    	response = self.class.post(cmd, :body => body)
      @vertex_matching[id] = response.parsed_response["_id"]
    end
    
    def add_edge(edge_id, from, to)
      database_id_for_first_node = @vertex_matching[from]
      database_id_for_second_node = @vertex_matching[to]
      
      cmd = "/edge?collection=#{@edge_collection_name}&from=#{database_id_for_first_node}&to=#{database_id_for_second_node}"
    	body = "{ \"id\" : \"#{edge_id}\" }"
    	response = self.class.post(cmd, :body => body)
      @edge_matching[edge_id] = response.parsed_response["_id"]
    end
    
    def close
      
    end
    
    private
    
    def drop_and_create_collection(name)
      self.class.delete "/_api/collection/#{name}"
      self.class.post "/_api/collection", body: "{ \"name\" : \"#{name}\"}"
    end
  end
end