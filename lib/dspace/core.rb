# frozen_string_literal: true

module DSpace
  module Core
    autoload(:Config, File.join(File.dirname(__FILE__), 'config'))
    autoload(:Constants, File.join(File.dirname(__FILE__), 'constants'))
    autoload(:ObjectBehavior, File.join(File.dirname(__FILE__), 'object_behavior'))
    autoload(:DSpaceObjectBehavior, File.join(File.dirname(__FILE__), 'dspace_object_behavior'))
    autoload(:EPerson, File.join(File.dirname(__FILE__),  'eperson'))
    autoload(:Group, File.join(File.dirname(__FILE__) 'group'))
    autoload(:Collection, File.join(File.dirname(__FILE__), 'collection'))
    autoload(:Community, File.join(File.dirname(__FILE__), 'community'))
    autoload(:Item, File.join(File.dirname(__FILE__), 'item'))
    autoload(:Bitstream, File.join(File.dirname(__FILE__), 'bitstream'))
    autoload(:Bundle, File.join(File.dirname(__FILE__), 'bundle'))
    autoload(:Work, File.join(File.dirname(__FILE__), 'work'))
    autoload(:Metadata, File.join(File.dirname(__FILE__), 'metadata'))
  end
end
