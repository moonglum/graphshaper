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
    
    it "should calculate the vertex degree" do
      expect { @graph.add_edge 0,1 }.to change { @graph.vertex_degree_for 1}.by(1)
    end
    
    it "should calculate the degree distribution" do
      @graph.degree_distribution.should ==[5]
      @graph.add_edge 0,1
      @graph.add_edge 1,2
      @graph.degree_distribution.should ==[2,2,1]
    end
  end
  
  describe "random generated graph without orphans" do
    before :each do
      @graph = Graphshaper::UndirectedGraph.without_orphans_with_order_of 15
    end
    
    it "should have the correct order" do
      @graph.order.should ==(15)
    end
    
    it "should have no orphans" do
      @graph.number_of_orphans.should ==(0)
    end
  end
  
  describe "calculating the node's degree and preferential attachment" do
    before :each do
      @graph = Graphshaper::UndirectedGraph.new 5
    end
    
    it "should calculate the degree of 0 for every vertex in a graph without edges" do
      5.times do |node_id|
        @graph.calculate_node_degree_for(node_id).should ==0
      end
    end
    
    it "should calculate the degree for a vertex with two edges" do
      @graph.add_edge 0,1
      @graph.add_edge 1,2
      @graph.calculate_node_degree_for(1).should ==2
    end
    
    it "should calculate the sum of all degrees" do
      @graph.add_edge 0,1
      @graph.add_edge 1,2
      @graph.sum_of_all_degrees.should ==4
    end
    
    it "should provide an iterator for preferential attachments that sums up to 0 for a graph without edges" do
      sum = 0
      @graph.each_preferential_attachment do |preferential_attachment|
        sum += preferential_attachment
      end
      sum.should ==0
    end
    
    it "should calculate the preferential attachments in a way that their sum is always 1 when there is at least one edge" do
      sum = 0
      @graph.add_edge 0,1
      @graph.each_preferential_attachment do |preferential_attachment|
        sum += preferential_attachment
      end
      sum.should ==1
    end
    
    it "should add up the preferential attachments to one even if edges are added in the block" do
      sum = 0
      @graph.add_edge 0,1
      @graph.each_preferential_attachment do |preferential_attachment|
        @graph.add_edge 1,3 if @graph.size < 2
        sum += preferential_attachment
      end
      sum.should ==1
    end
  end
end