# frozen_string_literal: true

module DSpace
  module Core
    autoload(:Config, './config')
    autoload(:Constants, './constants')
    autoload(:ObjectBehavior, './object_behavior')
    autoload(:DSpaceObjectBehavior, './dspace_object_behavior')
    autoload(:EPerson, './eperson')
    autoload(:Group, './group')
    autoload(:Collection, './collection')
    autoload(:Community, './community')
    autoload(:Item, './item')
    autoload(:Bitstream, './bitstream')
    autoload(:Bundle, './bundle')
    autoload(:Work, './work')
    autoload(:Metadata, './metadata')
  end
end
