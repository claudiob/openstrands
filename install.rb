require 'fileutils'

# INSTALL CONFIG FILE 
FileUtils.cp "#{File.dirname(__FILE__)}/example/openstrands.yml", 
  "#{RAILS_ROOT}/config/openstrands.yml"

puts File.read("#{File.dirname(__FILE__)}/README")

puts "IMPORTANT! The plugin will not work without a valid Openstrands key! :)"