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

  it "should register swfobject.js as a default javascript library" do
    @view.javascript_include_tag(:defaults).match(/"\/javascripts\/swfobject.js"/).should_not be_nil
  end

  it "should generate the zoomify markup" do
    @view.zoomify_image_tag('foo.jpg', { :id => 'foo', :alt => 'Foo Bar', :width => 800, :height => 500 }).should ==
      '<div id="foo"><img alt="Foo Bar" height="500" src="/images/foo.jpg" width="800" /></div>' +
      "<script type=\"text/javascript\">\n//<![CDATA[\n" +
      "swfobject.embedSWF('/swf/zoomifyViewer.swf', 'foo', '800', '500', '9.0.0', false, { zoomifyImagePath: '/images/foo/' });\n//]]>\n" +
      '</script>'
  end
end
