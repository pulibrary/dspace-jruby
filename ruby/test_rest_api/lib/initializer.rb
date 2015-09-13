ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'rails/all'

require 'dspace_rest'
require 'dspace_obj'
require 'dcommunity'
require 'dcollection'
require 'ditem'
require 'dbitstream'

module App
    BASE_URL  = "http://localhost:8080/rest"
    REST_API = DSpaceRest.new(BASE_URL)
end

#DCollection.list({})
#DCommunity.list({})
DItem.list({})
#DCommunity.find_by_id(111).collections({})
DItem.find_by_id(1898)