require "spec_helper"
require "graphshaper/adapters/dot_adapter.rb"

describe Graphshaper::DotAdapter do
  before :each do
    @output_file = double()
    @output_file.stub :<<
  end
  
  it "should write a header into the file" do
    @output_file.should_receive(:<<).with("digraph genereated_graph { \n  rankdir=LR;\n  node [shape = circle];\n  edge [dir=none];\n")
    Graphshaper::DotAdapter.new @output_file
  end
  
  describe "initialized Dot Adapter" do
    before :each do
      @dot_adapter = Graphshaper::DotAdapter.new @output_file
    end
    
    it "should be closeable" do
      @output_file.should_receive(:<<).with("}")
      @output_file.should_receive(:close)
      @dot_adapter.close
    end
    
    it "should write an edge in the correct format" do
      @output_file.should_receive(:<<).with("  1 -> 2 [ label = \"0\" ];\n")
      @dot_adapter.add_edge(0,1,2)
    end
    
    it "should write a vertex in the correct format" do
      @output_file.should_receive(:<<).with("  15;\n")
      @dot_adapter.add_vertex(15)
    end
  end
end