require File.dirname(__FILE__) + '/spec_helper'
require 'zoomifier_helper'

class MockActionView
  include Zoomifier::ViewHelpers
end

describe Zoomifier::ViewHelpers do
  before(:each) do
    @view = MockActionView.new
  end

  it "should respond to zoomify_image_tag" do
    @view.should respond_to(:zoomify_image_tag)
  end
end
