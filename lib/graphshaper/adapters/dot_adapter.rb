module Graphshaper
  class DotAdapter
    def initialize(output_file)
      @output_file = output_file
      @output_file << "digraph genereated_graph { \n  rankdir=LR;\n  node [shape = circle];\n  edge [dir=none];\n"
    end
    
    def add_edge(edge_id, in_id, out_id)
      @output_file << "  #{in_id} -> #{out_id} [ label = \"#{edge_id}\" ];\n"
    end
    
    def add_vertex(vertex_id)
      @output_file << "  #{vertex_id};\n"
    end
    
    def close
      @output_file << "}"
      @output_file.close
    end
  end
end