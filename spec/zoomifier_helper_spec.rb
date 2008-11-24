require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../../../../config/environment'
require 'zoomifier_helper'

describe Zoomifier::ViewHelpers do
  before(:all) do
    ActionView::Base.send :include, Zoomifier::ViewHelpers
  end

  before(:each) do
    @view = ActionView::Base.new
  end

  it "should respond to zoomify_image_tag" do
    @view.should respond_to(:zoomify_image_tag)
  end

  it "should generate the zoomify markup" do
    @view.zoomify_image_tag('foo.jpg', { :id => 'foo' }).should ==
      '<div id="foo"><img src="foo.jpg" alt=""/></div>'
  end
end
