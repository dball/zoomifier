require 'fileutils'
require 'open-uri'
require 'rubygems'
require 'rmagick'

# Breaks up images into tiles suitable for viewing with Zoomify.
# See http://zoomify.com/ for more details.
#
# @author Donald A. Ball Jr. <donald.ball@gmail.com>
# @version 1.2
# @copyright (C) 2008 Donald A. Ball Jr.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

module Zoomifier

  TILESIZE = 256

  # Zoomifies the image file specified by filename. The zoomified directory
  # name will be the filename without its extension, e.g. 5.jpg will be
  # zoomified into a directory named 5. If there is already a directory with
  # this name, it will be destroyed without mercy.
  def self.zoomify(filename)
    raise ArgumentError unless filename && File.file?(filename)
    #filename = File.expand_path(filename)
    outputdir = File.dirname(filename) + '/' + File.basename(filename, '.*')
    raise ArgumentError unless filename != outputdir
    if File.directory?(outputdir) && File.file?(outputdir + '/ImageProperties.xml') && File.mtime(filename) <= File.mtime(outputdir + '/ImageProperties.xml')
      return
    end
    FileUtils.rm_rf(outputdir) if File.exists?(outputdir)
    Dir.mkdir(outputdir)
    tmpdir = "#{outputdir}/tmp"
    Dir.mkdir(tmpdir)
    tilesdir = nil
    image = Magick::Image.read(filename).first.strip!
    # Each level of zoom is a factor of 2. Here we obtain the number of zooms
    # allowed by the original file dimensions and the constant tile size.
    levels = (Math.log([image.rows, image.columns].max.to_f / TILESIZE) / Math.log(2)).ceil
    tiles = 0
    (0..levels).each do |level|
      n = levels - level
      # Obtain the image to tile for this level. The 0th level should consist
      # of one tile, while the highest level should be the original image.
      level_image = image.resize(image.columns >> n, image.rows >> n)
      tiles(tmpdir, level, level_image) do |filename|
        # The tile images are chunked into directories named TileGroupN, N
        # starting at 0 and increasing monotonically. Each directory contains
        # at most 256 images. The images are sorted by level, tile row, and
        # tile column.
        div, mod = tiles.divmod(256)
        if mod == 0
          tilesdir = "#{outputdir}/TileGroup#{div}"
          Dir.mkdir(tilesdir)
        end
        FileUtils.mv("#{tmpdir}/#{filename}", "#{tilesdir}/#{filename}")
        tiles += 1
      end
      # Rmagick needs a bit of help freeing image memory.
      level_image = nil
      GC.start
    end
    File.open("#{outputdir}/ImageProperties.xml", 'w') do |f|
      f.write("<IMAGE_PROPERTIES WIDTH=\"#{image.columns}\" HEIGHT=\"#{image.rows}\" NUMTILES=\"#{tiles}\" NUMIMAGES=\"1\" VERSION=\"1.8\" TILESIZE=\"#{TILESIZE}\" />")
    end
    Dir.rmdir(tmpdir)
    outputdir
  end

  # Splits the given image up into images of TILESIZE, writes them to the
  # given directory, and yields their names
  def self.tiles(dir, level, image)
    slice(image.rows).each_with_index do |y_slice, j|
      slice(image.columns).each_with_index do |x_slice, i|
        # The images are named "level-column-row.jpg"
        filename = "#{level}-#{i}-#{j}.jpg"
        tile_image = image.crop(x_slice[0], y_slice[0], x_slice[1], y_slice[1])
        tile_image.write("#{dir}/#{filename}") do
          # FIXME - the images end up being 4-5x larger than those produced
          # by Zoomifier EZ and friends... no idea why just yet, except to note
          # that the density of these tiles ends up being 400x400, while
          # everybody else produces tiles at 72x72. Can't see why that would
          # matter though...
          self.quality = 80 
        end
        # Rmagick needs a bit of help freeing image memory.
        tile_image = nil
        GC.start
        yield filename
      end
    end
  end

  # Returns an array of slices ([offset, length]) obtained by slicing the
  # given number by TILESIZE.
  # E.g. 256 -> [[0, 256]], 257 -> [[0, 256], [256, 1]],
  #      513 -> [[0, 256], [256, 256], [512, 1]]
  def self.slice(n)
    results = []
    i = 0
    while true
      if i + TILESIZE >= n
        results << [i, n-i]
        break
      else
        results << [i, TILESIZE]
        i += TILESIZE
      end
    end
    results
  end

  def self.unzoomify(url)
    tmpdir = 'tmp'
    FileUtils.rm_rf(tmpdir) if File.exists?(tmpdir)
    Dir.mkdir(tmpdir)
    doc = nil
    begin
      open("#{url}/ImageProperties.xml") do |f|
        doc = REXML::Document.new(f)
      end
    rescue OpenURI::HTTPError
      return nil
    end
    attrs = doc.root.attributes
    return nil unless attrs['TILESIZE'] == '256' && attrs['VERSION'] == '1.8'
    width = attrs['WIDTH'].to_i
    height = attrs['HEIGHT'].to_i
    tiles = attrs['NUMTILES'].to_i
    image_paths = (0 .. tiles/256).map {|n| "TileGroup#{n}"}
    max_level = 0
    while (get_tile(url, image_paths, tmpdir, "#{max_level}-0-0.jpg"))
      max_level += 1
    end
    max_level -= 1
    image = Magick::Image.new(width, height)
    (0 .. width / TILESIZE).each do |column|
      (0 .. height / TILESIZE).each do |row|
        filename = "#{max_level}-#{column}-#{row}.jpg"
        get_tile(url, image_paths, tmpdir, filename)
        tile_image = Magick::Image.read("#{tmpdir}/#{filename}").first
        image.composite!(tile_image, column*TILESIZE, row*TILESIZE, Magick::OverCompositeOp)
        time_image = nil
        GC.start
      end
    end
    # FIXME - get filename from the url
    image.write('file.jpg') { self.quality = 90 }
    image = nil
    GC.start
    FileUtils.rm_rf(tmpdir)
  end

  # TODO - could reduce the miss rate by using heuristics to guess the
  # proper path from which to download the file
  def self.get_tile(url, image_paths, tmpdir, filename)
    image_paths.each do |path|
      begin
        open("#{tmpdir}/#{filename}", 'wb') {|f| f.write(open("#{url}/#{path}/#{filename}").read)}
        return filename
      rescue OpenURI::HTTPError
      end
    end
    nil
  end 
  
end

if __FILE__ == $0
  if ARGV.length == 1
    Zoomifier::zoomify(ARGV[0])
  else
    puts "Usage: zoomify filename"
  end
end
