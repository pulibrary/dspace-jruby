#!/usr/bin/env jruby -I lib
require "highline/import"
require 'dspace'

objs = ARGV
if objs.empty? then 
   objs <<  ask("enter handle or <TYPE>.<ID> ")
end

DSpace.load

objs.each do |obj| 
    d = DSO.fromString(obj)
    if (d) then 
        puts obj; 
        puts JSON.pretty_generate(DSO.report(d))
        puts 
    else 
       puts "ERROR: no such object #{obj}"
    end
   puts "";
end

