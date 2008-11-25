module Zoomifier
  module ViewHelpers
    def zoomify_image_tag(source, options = {})
      raise ArgumentError unless [:id, :width, :height].all? {|o| options[o] }
      if File.file?(path = RAILS_ROOT + '/public/images/' + source)
        Zoomifier::zoomify(path)
      end
      s = content_tag :div, { :id => options[:id] } do
        image_tag source, options.merge({ :id => nil })
      end
      zoomify_path = image_path(source).gsub(/\.[^.]+$/, '')
      s += javascript_tag "swfobject.embedSWF('/swfs/zoomifyViewer.swf', '#{options[:id]}', '#{options[:width]}', '#{options[:height]}', '9.0.0', false, { zoomifyImagePath: '#{zoomify_path}/' });"
      s
    end
  end
end
