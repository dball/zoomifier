require File.dirname(__FILE__) + '/spec_helper'
require 'zoomifier'

describe Zoomifier do
  it "should respond to its main method" do
    Zoomifier.should respond_to(:zoomify)
  end
end
