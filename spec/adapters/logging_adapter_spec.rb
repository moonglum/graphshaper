require "spec_helper"
require "graphshaper/adapters/logging_adapter"

describe Graphshaper::LoggingAdapter do
  before :each do
    @vertex_logger = double()
    @vertex_logger.stub :<<
    @edge_logger = double()
    @edge_logger.stub :<<
  end

  it "should write a header into the files" do
    @vertex_logger.should_receive(:<<).with("vertex_id\n")
    @edge_logger.should_receive(:<<).with("edge_id,from_id,to_id\n")
    Graphshaper::LoggingAdapter.new @vertex_logger, @edge_logger
  end

  describe "Initialized Logger" do
    before :each do
      @adapter = Graphshaper::LoggingAdapter.new @vertex_logger, @edge_logger
    end

    it "should write edges to the logger at edge creation" do
      @edge_logger.should_receive(:<<).with("0,1,3\n")
      @adapter.add_edge 0,1,3
    end

    it "should write vertices to the logger at vertex creation" do
      @vertex_logger.should_receive(:<<).with("5\n")
      @adapter.add_vertex 5
    end
  end
end
