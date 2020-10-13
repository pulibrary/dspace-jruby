# frozen_string_literal: true

module DSpace
  module Core
    autoload(:Config, File.join(File.dirname(__FILE__), 'core', 'config'))
    autoload(:Constants, File.join(File.dirname(__FILE__), 'core', 'constants'))
    autoload(:ObjectBehavior, File.join(File.dirname(__FILE__), 'core', 'object_behavior'))
    autoload(:DSpaceObjectBehavior, File.join(File.dirname(__FILE__), 'core', 'dspace_object_behavior'))
    autoload(:EPerson, File.join(File.dirname(__FILE__), 'core', 'eperson'))
    autoload(:Group, File.join(File.dirname(__FILE__), 'core', 'group'))
    autoload(:Collection, File.join(File.dirname(__FILE__), 'core', 'collection'))
    autoload(:Community, File.join(File.dirname(__FILE__), 'core', 'community'))
    autoload(:Item, File.join(File.dirname(__FILE__), 'core', 'item'))
    autoload(:Bitstream, File.join(File.dirname(__FILE__), 'core', 'bitstream'))
    autoload(:Bundle, File.join(File.dirname(__FILE__), 'core', 'bundle'))
    autoload(:Work, File.join(File.dirname(__FILE__), 'core', 'work'))
    autoload(:Metadata, File.join(File.dirname(__FILE__), 'core', 'metadata'))
  end
end
