require "spec_helper"
require "graphshaper/adapters/arangodb_adapter"

describe Graphshaper::ArangoDbAdapter do
  before :each do
    stub_request(:delete, "http://localhost:8529/_api/collection/vertices").to_return(:status => 200, :body => "", :headers => {})
    stub_request(:post, "http://localhost:8529/_api/collection").with(:body => "{ \"name\" : \"vertices\"}")
    stub_request(:delete, "http://localhost:8529/_api/collection/edges").to_return(:status => 200, :body => "", :headers => {})
    stub_request(:post, "http://localhost:8529/_api/collection").with(:body => "{ \"name\" : \"edges\"}")
    stub_request(:post, "http://localhost:8529/document?collection=vertices")
      .with(:body => "{ \"id\" : \"1\" }")
      .to_return(:body => "{ \"_rev\": 26445614, \"_id\": \"73482/26445614\", \"error\": false }", :status => 200 )
    stub_request(:post, "http://localhost:8529/document?collection=vertices")
      .with(:body => "{ \"id\" : \"2\" }")
      .to_return(:body => "{ \"_rev\": 26445614, \"_id\": \"73482/26445615\", \"error\": false }", :status => 200 )
    stub_request(:post, "http://localhost:8529/edge?collection=edges&from=73482/26445614&to=73482/26445615")
      .with(:body => "{ \"id\" : \"7\" }")
      .to_return(:body => "{ \"_rev\": 9683012, \"_id\": \"7848004/9683012\", \"error\": false }", :status => 200)
    
    @arango_adapter = Graphshaper::ArangoDbAdapter.new "vertices", "edges"
  end
  
  it "should drop the collections on startup" do
    WebMock.should have_requested(:delete, "http://localhost:8529/_api/collection/vertices")
    WebMock.should have_requested(:delete, "http://localhost:8529/_api/collection/edges")
  end
  
  it "should create the collections on startup" do
    WebMock.should have_requested(:post,   "http://localhost:8529/_api/collection").with(:body => "{ \"name\" : \"vertices\"}")
    WebMock.should have_requested(:post,   "http://localhost:8529/_api/collection").with(:body => "{ \"name\" : \"edges\"}")    
  end
  
  it "should add a vertex" do
    @arango_adapter.add_vertex 1
    
    WebMock.should have_requested(:post, "http://localhost:8529/document?collection=vertices").with(:body => "{ \"id\" : \"1\" }")
  end
  
  it "should add an edge with the correct vertex ids" do
    @arango_adapter.add_vertex 1
    @arango_adapter.add_vertex 2
    @arango_adapter.add_edge 7, 1, 2
    
    WebMock.should have_requested(:post, "http://localhost:8529/edge?collection=edges&from=73482/26445614&to=73482/26445615").with(:body => "{ \"id\" : \"7\" }")
  end
end
