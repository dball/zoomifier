require File.dirname(__FILE__) + '/spec_helper'
require 'zoomifier'

describe Zoomifier do
  it "should respond to its main method" do
    Zoomifier.should respond_to(:zoomify)
  end

  describe "On a 1024x768 JPEG file" do
    before(:all) do
      @input = File.dirname(__FILE__) + '/data/1024x768.jpg'
      @output = File.dirname(__FILE__) + '/data/1024x768/'
      @tiles = %w[0-0-0.jpg 1-1-1.jpg 2-1-0.jpg 2-2-1.jpg 2-3-2.jpg
                  1-0-0.jpg 2-0-0.jpg 2-1-1.jpg 2-2-2.jpg
                  1-0-1.jpg 2-0-1.jpg 2-1-2.jpg 2-3-0.jpg
                  1-1-0.jpg 2-0-2.jpg 2-2-0.jpg 2-3-1.jpg]
      FileUtils.rm_rf(@output)
      Zoomifier::zoomify(@input)
    end

    after(:all) do
      FileUtils.rm_rf(@output)
    end

    it "should create the output directory" do
      File.directory?(@output).should be_true
    end

    it "should create the image properties file" do
      File.file?(@output + '/ImageProperties.xml').should be_true
    end

    it "should create a tile group directory" do
      File.directory?(@output + '/TileGroup0/').should be_true
    end

    it "should create the tiled images" do
      tile_images = Dir.entries(@output + '/TileGroup0/').reject {|f| f.match(/^\./)}
      tile_images.sort.should == @tiles.sort
      tile_images.each do |file|
        image = Magick::Image.read(@output + '/TileGroup0/' + file).first
        image.rows.should <= 256
        image.columns.should <= 256
      end
    end
  end
end
