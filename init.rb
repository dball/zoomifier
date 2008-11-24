require 'zoomifier'
require 'zoomifier_helper'

ActionView::Helpers::AssetTagHelper::register_javascript_include_default 'swfobject'
ActionView::Base.send :include, Zoomifier::ViewHelpers
