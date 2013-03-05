module Graphshaper
  # An adapter to generate JSON files in the format specified by Michael Hackstein
  class JsonAdapter
    def initialize(base_path, file_class = File)
      @base_path = base_path
      @file_class = file_class
      @vertex_file_names = []
    end

    def add_edge(edge_id, from_id, to_id)
      file_name = "#{@base_path}/#{from_id}.json"
      file = @file_class.new(file_name, "a")
      file.write(%Q<{"id":#{to_id}},>)
      file.close
    end

    def add_vertex(vertex_id)
      file_name = "#{@base_path}/#{vertex_id}.json"
      @vertex_file_names << file_name
      file = @file_class.new(file_name, "w")
      file.write(file_header(vertex_id))
      file.close
    end

    def close
      @vertex_file_names.each do |file_name|
        content = @file_class.read(file_name).gsub(/,\z/, '')
        file = @file_class.new(file_name, "w+")
        file.write("#{content}]}")
        file.close
      end
    end

    private

    def file_header(id)
      %Q<{"id":#{id},"children" : [>
    end
  end
end
