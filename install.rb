PLUGIN_ROOT = File.dirname(__FILE__)
#RAILS_ROOT = PLUGIN_ROOT + '/../../..'
unless File.directory?(RAILS_ROOT + '/public/swfs')
  FileUtils.mkdir(RAILS_ROOT + '/public/swfs')
end
FileUtils.copy(PLUGIN_ROOT + '/assets/zoomifyViewer.swf',
  RAILS_ROOT + '/public/swfs/')
FileUtils.copy(PLUGIN_ROOT + '/assets/swfobject.js',
  RAILS_ROOT + '/public/javascripts/')
