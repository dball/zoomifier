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

  describe "On a 2973x2159 JPEG file" do
    before(:all) do
      @input = File.dirname(__FILE__) + '/data/2973x2159.jpg'
      @output = File.dirname(__FILE__) + '/data/2973x2159/'
      @tiles = %w[
      0-0-0.jpg 3-3-2.jpg   4-10-0.jpg  4-3-4.jpg   4-6-8.jpg
      1-0-0.jpg 3-3-3.jpg   4-10-1.jpg  4-3-5.jpg   4-7-0.jpg
      1-0-1.jpg 3-3-4.jpg   4-10-2.jpg  4-3-6.jpg   4-7-1.jpg
      1-1-0.jpg 3-4-0.jpg   4-10-3.jpg  4-3-7.jpg   4-7-2.jpg
      1-1-1.jpg 3-4-1.jpg   4-10-4.jpg  4-3-8.jpg   4-7-3.jpg
      2-0-0.jpg 3-4-2.jpg   4-10-5.jpg  4-4-0.jpg   4-7-4.jpg
      2-0-1.jpg 3-4-3.jpg   4-10-6.jpg  4-4-1.jpg   4-7-5.jpg
      2-0-2.jpg 3-4-4.jpg   4-10-7.jpg  4-4-2.jpg   4-7-6.jpg
      2-1-0.jpg 3-5-0.jpg   4-10-8.jpg  4-4-3.jpg   4-7-7.jpg
      2-1-1.jpg 3-5-1.jpg   4-11-0.jpg  4-4-4.jpg   4-7-8.jpg
      2-1-2.jpg 3-5-2.jpg   4-11-1.jpg  4-4-5.jpg   4-8-0.jpg
      2-2-0.jpg 3-5-3.jpg   4-11-2.jpg  4-4-6.jpg   4-8-1.jpg
      2-2-1.jpg 3-5-4.jpg   4-11-3.jpg  4-4-7.jpg   4-8-2.jpg
      2-2-2.jpg 4-0-0.jpg   4-11-4.jpg  4-4-8.jpg   4-8-3.jpg
      3-0-0.jpg 4-0-1.jpg   4-11-5.jpg  4-5-0.jpg   4-8-4.jpg
      3-0-1.jpg 4-0-2.jpg   4-11-6.jpg  4-5-1.jpg   4-8-5.jpg
      3-0-2.jpg 4-0-3.jpg   4-11-7.jpg  4-5-2.jpg   4-8-6.jpg
      3-0-3.jpg 4-0-4.jpg   4-11-8.jpg  4-5-3.jpg   4-8-7.jpg
      3-0-4.jpg 4-0-5.jpg   4-2-0.jpg   4-5-4.jpg   4-8-8.jpg
      3-1-0.jpg 4-0-6.jpg   4-2-1.jpg   4-5-5.jpg   4-9-0.jpg
      3-1-1.jpg 4-0-7.jpg   4-2-2.jpg   4-5-6.jpg   4-9-1.jpg
      3-1-2.jpg 4-0-8.jpg   4-2-3.jpg   4-5-7.jpg   4-9-2.jpg
      3-1-3.jpg 4-1-0.jpg   4-2-4.jpg   4-5-8.jpg   4-9-3.jpg
      3-1-4.jpg 4-1-1.jpg   4-2-5.jpg   4-6-0.jpg   4-9-4.jpg
      3-2-0.jpg 4-1-2.jpg   4-2-6.jpg   4-6-1.jpg   4-9-5.jpg
      3-2-1.jpg 4-1-3.jpg   4-2-7.jpg   4-6-2.jpg   4-9-6.jpg
      3-2-2.jpg 4-1-4.jpg   4-2-8.jpg   4-6-3.jpg   4-9-7.jpg
      3-2-3.jpg 4-1-5.jpg   4-3-0.jpg   4-6-4.jpg   4-9-8.jpg
      3-2-4.jpg 4-1-6.jpg   4-3-1.jpg   4-6-5.jpg
      3-3-0.jpg 4-1-7.jpg   4-3-2.jpg   4-6-6.jpg
      3-3-1.jpg 4-1-8.jpg   4-3-3.jpg   4-6-7.jpg]
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
