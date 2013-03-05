require "spec_helper"
require "graphshaper/adapters/json_adapter"

describe Graphshaper::JsonAdapter do
  describe "Initialized Adapter" do
    let(:file_class) { double }
    let(:vertex_id)  { 1 }
    let(:edge_id)    { 2 }
    let(:from_id)    { 3 }
    let(:to_id)      { 4 }
    subject { Graphshaper::JsonAdapter.new "test_dir", file_class }

    it "should create a new edge file" do
      file = double
      file.should_receive(:write).with(%Q<{"id":#{vertex_id},"children" : [>)
      file.should_receive(:close)
      file_class.stub(:new).and_return { file }
      file_class.should_receive(:new).with("test_dir/#{vertex_id}.json", "w")

      subject.add_vertex(vertex_id)
    end

    it "should add edges to the vertices" do
      file = double
      file.should_receive(:write).with(%Q<{"id":#{to_id}},>)
      file.should_receive(:close)
      file_class.stub(:new).and_return { file }
      file_class.should_receive(:new).with("test_dir/#{from_id}.json", "a")

      subject.add_edge(edge_id, from_id, to_id)
    end

    it "should close all vertex files" do
      file_1 = double
      file_2 = double
      close_file_1 = double
      close_file_2 = double

      [file_1, file_2, close_file_1, close_file_2].each do |f|
        f.stub(:write)
        f.stub(:close)
      end

      [close_file_1, close_file_2].each do |f|
        f.should_receive(:write).with("a]}")
        f.should_receive(:close)
      end

      file_class.stub(:read).with("test_dir/1.json").and_return { "a," }
      file_class.stub(:read).with("test_dir/2.json").and_return { "a" }

      file_class.stub(:new).with("test_dir/1.json", "w").and_return { file_1 }
      file_class.stub(:new).with("test_dir/2.json", "w").and_return { file_2 }

      file_class.stub(:new).with("test_dir/1.json", "w+").and_return { close_file_1 }
      file_class.stub(:new).with("test_dir/2.json", "w+").and_return { close_file_2 }

      subject.add_vertex(1)
      subject.add_vertex(2)
      subject.close
    end
  end
end
