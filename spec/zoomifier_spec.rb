require File.dirname(__FILE__) + '/spec_helper'
require 'zoomifier'

describe Zoomifier do
  it "should respond to its main method" do
    Zoomifier.should respond_to(:zoomify)
  end

  describe "1024x768.jpg" do
    it "should zoomify" do
      output = File.dirname(__FILE__) + '/data/1024x768/'
      FileUtils.rm_rf(output)
      input = File.dirname(__FILE__) + '/data/1024x768.jpg'
      Zoomifier::zoomify(input)
      File.directory?(output).should be_true
      FileUtils.rm_rf(output)
    end
  end
end
