require "spec_helper"

describe Graphshaper::UndirectedGraph do
  it "should create a graph with a given number of nodes and no edges" do
    graph = Graphshaper::UndirectedGraph.new 5
    graph.order.should ==(5)
    graph.size.should ==(0)
  end
  
  describe "initialized graph" do
    before :each do
      @graph = Graphshaper::UndirectedGraph.new 5
    end
    
    it "should be able to add new vertices" do
      expect { @graph.add_vertex }.to change{ @graph.order }.by(1)
    end
    
    it "should add a vertex with two existing ids" do
      expect { @graph.add_edge 0, 1 }.to change{ @graph.size }.by(1)
    end
    
    it "shouldn't add a vertex if one of the ids doesn't exist" do
      expect { @graph.add_edge 0, 5}.to raise_error(RuntimeError, "ID doesn't exist")
    end
    
    it "should answer the question if there is an edge between two nodes with false if they are not" do
      @graph.edge_between?(0,1).should be_false
    end
    
    it "should answer the question if there is an edge between two nodes with true if they are" do
      @graph.add_edge 0,1
      @graph.edge_between?(0,1).should be_true
    end
    
    it "shouldn't add an edge that has already been added" do
      @graph.add_edge 0,1
      expect { @graph.add_edge 0, 1 }.to change{ @graph.size }.by(0)
    end
    
    it "shouldn't add an edge that has already been added - independent of direction" do
      @graph.add_edge 0,1
      expect { @graph.add_edge 1,0 }.to change{ @graph.size }.by(0)
    end
    
    it "should not add an edge where the first and second node are the same" do
      expect { @graph.add_edge 0, 0}.to raise_error(RuntimeError, "No Self-Referential Edge")
    end
    
    it "should return the graph's order for the number of orphans for a graph without vertices" do
      @graph.number_of_orphans.should ==(@graph.order)
    end
    
    it "should return 0 for the number of orphans for a graph connected in a circle" do
      circle_array = (0...5).to_a
      circle_array.zip(circle_array.rotate).each do |node_a, node_b|
        @graph.add_edge node_a, node_b
      end
    end
  end
end