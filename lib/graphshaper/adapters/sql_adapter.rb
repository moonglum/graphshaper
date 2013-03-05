module Graphshaper
  class SqlAdapter
    def initialize(schema_file, vertex_file, edge_file)
      @schema_file = schema_file
      @vertex_file = vertex_file
      @edge_file = edge_file

      File.readlines("templates/schema.sql").each do |schema_line|
        @schema_file << schema_line
      end

      @vertex_file << "LOCK TABLES `vertices` WRITE;\n"
      @vertex_file << "INSERT INTO `vertices` (`id`, `vertex_id`)\n"
      @vertex_file << "VALUES\n\t"

      @edge_file << "LOCK TABLES `edges` WRITE;\n"
      @edge_file << "INSERT INTO `edges` (`id`, `edge_id`, `from_id`, `to_id`)\n"
      @edge_file << "VALUES\n\t"

      @first_vertex = true
      @first_edge = true
    end

    def add_vertex(vertex_id)
      @vertex_file << ",\n\t" unless @first_vertex
      @vertex_file << "(#{vertex_id + 1},#{vertex_id})"
      @first_vertex = false
    end

    def add_edge(edge_id, from_id, to_id)
      @edge_file << ",\n\t" unless @first_edge
      @edge_file << "(#{edge_id + 1},#{edge_id},#{from_id + 1},#{to_id + 1})"
      @first_edge = false
    end

    def close
      [@vertex_file, @edge_file].each { |file| file << ";\nUNLOCK TABLES;"}
      [@schema_file, @vertex_file, @edge_file].each { |file| file.close }
    end
  end
end
