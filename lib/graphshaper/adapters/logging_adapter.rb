module Graphshaper
  
  # A simple adapter for logging the created graph
  class LoggingAdapter
    def initialize(vertex_logger_file, edge_logger_file)
      @vertex_logger_file = vertex_logger_file
      @edge_logger_file = edge_logger_file
      @vertex_logger_file << "vertex_id\n"
      @edge_logger_file << "edge_id,from_id,to_id\n"
    end
    
    def add_edge(edge_id, from_id, to_id)
      @edge_logger_file << "#{edge_id},#{from_id},#{to_id}\n"
    end
    
    def add_vertex(vertex_id)
      @vertex_logger_file << "#{vertex_id}\n"
    end
    
    def close
      @vertex_logger_file.close
      @edge_logger_file.close
    end
  end
end