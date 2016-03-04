#!/usr/bin/env jruby -I lib
require "highline/import"
require 'dspace'

objs = ARGV
if objs.empty? then 
   objs <<  ask("enter handle or <TYPE>.<ID> ")
end

DSpace.load

objs.each do |hdl|
    obj = DSO.fromString(hdl)
    if (obj) then
        vals = []
        parents = DSO.parents(obj)
        parents.reverse.each do |p|
          vals << p.getHandle << p.getName
        end
        vals << obj.getHandle << obj.getName;
        puts vals.join("\t")
    else 
       puts "ERROR: no such object #{hdl}"
    end
   puts "";
end

