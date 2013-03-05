require 'stringio'
require "spec_helper"
require "graphshaper/adapters/sql_adapter"

describe Graphshaper::SqlAdapter do
  before :each do
    @schema_file = StringIO.new
    @vertex_file = StringIO.new
    @edge_file = StringIO.new
  end

  describe "generated files" do
    before :each do
      @sql_adapter = Graphshaper::SqlAdapter.new @schema_file, @vertex_file, @edge_file
    end

    it "should write the schema to the file" do
      schema_string = @schema_file.string

      File.readlines("templates/schema.sql").each do |schema_line|
        schema_string.should include(schema_line)
      end
    end

    it "should write the vertices to the file" do
      @sql_adapter.add_vertex(0)
      @sql_adapter.add_vertex(1)
      @sql_adapter.close

      vertex_string = @vertex_file.string

      vertex_string.should include("	(1,0),\n")
      vertex_string.should include("	(2,1);\n")
    end

    it "should write the vertices to the file" do
      @sql_adapter.add_edge(0,5,6)
      @sql_adapter.add_edge(1,7,8)
      @sql_adapter.close

      edge_string = @edge_file.string

      edge_string.should include("	(1,0,6,7),\n")
      edge_string.should include("	(2,1,8,9);\n")
    end
  end

  it "should close the three files" do
    @schema_file.should_receive(:close)
    @edge_file.should_receive(:close)
    @vertex_file.should_receive(:close)

    sql_adapter = Graphshaper::SqlAdapter.new @schema_file, @vertex_file, @edge_file
    sql_adapter.close
  end
end
