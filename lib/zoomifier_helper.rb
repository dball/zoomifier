module Zoomifier
  module ViewHelpers
    def zoomify_image_tag(source, options = {})
      raise ArgumentError unless options[:id]
      "<div id=\"#{options[:id]}\"><img src=\"#{source}\" alt=\"\"/></div>"
    end
  end
end
