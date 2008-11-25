Zoomifier
=========
_Version 1.3 (November 24, 2008)_

__Authors:__  [Donald Ball](mailto:donald.ball@gmail.com)

__Copyright:__ Copyright (c) 2008, Donald Ball

__License:__ Apache Public License, v2.0

Zoomifier is a ruby library for creating directories of tiled images suitable for viewing with the free Zoomify flash player:

http://www.zoomify.com/

as well as a rails plugin that provides a helper method to make adding zoomified images to your rails app very easy.

## Installation

To install the plugin:

  script/plugin install git://github.com/dball/zoomifier.git

If you want the standalone library for whatever reason:

  sudo gem install dball-zoomifier

all this gets you is the zoomify script installed in your PATH, though, and the free convert released by Zoomify is quite a bit faster.

I'm working on a GemPlugin version, but I can't seem to figure out how you're supposed to have assets installed; there doesn't seem to be any command which runs the GemPlugin's install.rb script.

## Testing

Install the rspec gem, if you don't already have it, then run spec spec from the vendor/plugins/zoomifier directory.

## Usage

In your views, wherever you want a zoomified image:

  <%= zoomify_image_tag ('image.jpg', { :id => 'foo', :width => 400, :height => 300 }) %>

This will render a zoomified image with the specified dimensions using the swfobject Javascript library. An image tag with given attributes, except for the id (which is used to tag the div wrapper), is generated as a fallback for users without Javascript, so feel free to feed it alt and title and all that other good stuff as you see fit.

The directory of zoomified tiles is create in the same directory as the image, using its name without its extension, e.g. image/ in this example. The images will be automatically created if they do not exist already, or if the image file is newer than its tiles. Bear in mind this process can be fairly slow for large images, and of course, there's no point in zoomifying small images, so be patient on your first request. If there's sufficient, or, hell, any interest, I could write up some rake tasks to do this ahead of time.
