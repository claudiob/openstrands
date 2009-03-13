require 'rexml/document'
require 'net/http'
require "uri"

module Openstrands
  env = ENV['RAILS_ENV'] || RAILS_ENV
  config = YAML.load_file(RAILS_ROOT + '/config/openstrands.yml')[env]
  Key = config['api_key']

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def openstrands
      include Openstrands::InstanceMethods
    end    
    
  end

  module InstanceMethods

    def openstrands_lookup_track(id)
      path = "/internalservices/lookup/tracks?subscriberId=#{Key}&id=#{id}"
      fields_to_retrieve = ['TrackName', 'WmaClipURI', 'CoverURI', 'AlbumName',
                            'ArtistName', 'RmClipURI', 'RmMobileClipURI', 
                            'SmallCoverURI', 'Genre', 'URI']
      data = fetch_openstrands(path)
      if not data == false
        xml = REXML::Document.new(data)	
        track = {}
        fields_to_retrieve.each do |field|
          track[field.underscore] = xml.root.elements["SimpleTrack/#{field}"] ?
            xml.root.elements["SimpleTrack/#{field}"].text : ''
        end
        track.symbolize_keys!
        debugger
      end
      return track
    end 

  private
  
  def fetch_openstrands(path)
        http = Net::HTTP.new("www.mystrands.com",80)
        path = url(path)
        resp, data = http.get(path)
         if resp.code == "200"
           return data
         else
           return false
         end	
  end

  def url(string)
    return  string.gsub(/\ +/, '%20')
  end
  
  
  end
 
end