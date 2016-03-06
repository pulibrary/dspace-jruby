#!/usr/bin/env jruby -I lib

require 'dspace'
DSpace.load

puts "#Communities: #{DCommunity.all().count}";
puts "#Collections: #{DCollection.all().count}";
puts "#Froups: #{DGroup.all().count}";



