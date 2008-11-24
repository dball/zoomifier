module Zoomifier
  module ViewHelpers
    def zoomify_image_tag(source, options = {})
      raise ArgumentError unless options[:id]
      content_tag :div, { :id => options[:id] } do
        image_tag source, options.merge({ :id => nil })
      end
    end
  end
end
