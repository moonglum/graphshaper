require "spec_helper"

describe Graphshaper::Graph do
  it "should create a graph with a given number of nodes and no edges" do
    graph = Graphshaper::Graph.new 5
    graph.order.should ==(5)
    graph.size.should ==(0)
  end
  
  describe "initialized graph" do
    before :each do
      @graph = Graphshaper::Graph.new 5
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
    
    it "should answer the question if two nodes are connected with false if they are not" do
      @graph.connected?(0,1).should be_false
    end
    
    it "should answer the question if two nodes are connected with true if they are" do
      @graph.add_edge 0,1
      @graph.connected?(0,1).should be_true
    end
    
    it "shouldn't add an edge that has already been added" do
      @graph.add_edge 0,1
      expect { @graph.add_edge 0, 1 }.to change{ @graph.size }.by(0)
    end
  end
end