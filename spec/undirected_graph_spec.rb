require "spec_helper"
require "stringio" # for testing the logger

describe Graphshaper::UndirectedGraph do
  it "should create a graph with a given number of vertices and no edges" do
    graph = Graphshaper::UndirectedGraph.new 5
    graph.order.should ==(5)
    graph.size.should ==(0)
  end
  
  it "should create a graph with a logger for edge creation" do
    edge_creation_logger = StringIO.new
    graph = Graphshaper::UndirectedGraph.new 5, edge_creation_logger: edge_creation_logger
    
    graph.add_edge 1,3
    graph.add_edge 2,3
    edge_creation_logger.string.should ==("1,3\n2,3\n")
  end
  
  it "should create a graph with a logger for vertex creation" do
    vertex_creation_logger = StringIO.new
    graph = Graphshaper::UndirectedGraph.new 5, vertex_creation_logger: vertex_creation_logger
    
    graph.add_vertex
    vertex_creation_logger.string.should ==("0\n1\n2\n3\n4\n5\n")
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
    
    it "should answer the question if there is an edge between two vertices with false if they are not" do
      @graph.edge_between?(0,1).should be_false
    end
    
    it "should answer the question if there is an edge between two vertices with true if they are" do
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
    
    it "should not add an edge where the first and second vertex are the same" do
      expect { @graph.add_edge 0, 0}.to raise_error(RuntimeError, "No Self-Referential Edge")
    end
    
    it "should return the graph's order for the number of orphans for a graph without vertices" do
      @graph.number_of_orphans.should ==(@graph.order)
    end
    
    it "should return 0 for the number of orphans for a graph connected in a circle" do
      circle_array = (0...5).to_a
      circle_array.zip(circle_array.rotate).each do |vertex_a, vertex_b|
        @graph.add_edge vertex_a, vertex_b
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
  
  describe "calculating the vertex's degree and preferential attachment" do
    before :each do
      @graph = Graphshaper::UndirectedGraph.new 5
    end
    
    it "should calculate the degree of 0 for every vertex in a graph without edges" do
      5.times do |vertex_id|
        @graph.vertex_degree_for(vertex_id).should ==0
      end
    end
    
    it "should calculate the degree for a vertex with two edges" do
      @graph.add_edge 0,1
      @graph.add_edge 1,2
      @graph.vertex_degree_for(1).should ==2
    end
    
    it "should calculate the sum of all degrees" do
      @graph.add_edge 0,1
      @graph.add_edge 1,2
      @graph.sum_of_all_degrees.should ==4
    end
    
    it "should provide an iterator for preferential attachments that sums up to 0 for a graph without edges" do
      sum = 0
      @graph.each_vertex_with_preferential_attachment do |vertex_id, preferential_attachment|
        sum += preferential_attachment
      end
      sum.should ==0
    end
    
    it "should calculate the preferential attachments in a way that their sum is always 1 when there is at least one edge" do
      sum = 0
      @graph.add_edge 0,1
      @graph.each_vertex_with_preferential_attachment do |vertex_id, preferential_attachment|
        sum += preferential_attachment
      end
      sum.should ==1
    end
    
    it "should add up the preferential attachments to one even if edges are added in the block" do
      sum = 0
      @graph.add_edge 0,1
      @graph.each_vertex_with_preferential_attachment do |vertex_id, preferential_attachment|
        @graph.add_edge 1,3 if @graph.size < 2
        sum += preferential_attachment
      end
      sum.should ==1
    end
    
    it "should add a vertex to the graph with edges according to preferential attachment" do
      @graph.add_edge 0,1
      
      # Two vertices with preferential_attachment of 0.5, all others with 0
      @graph.add_vertex do |preferential_attachment|
        preferential_attachment > 0.4
      end
      
      # One more vertex
      @graph.order.should ==(6)
      
      # Two additional edges
      @graph.size.should ==(3)
    end
  end
end