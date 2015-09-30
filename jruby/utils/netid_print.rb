#!/usr/bin/env jruby -I lib
require "highline/import"
require 'dspace'

netids = ARGV
if netids.empty? then 
   netids <<  ask("enter netid ")
end

DSpace.load

def print_members(p)
  puts "#{p} (ID=#{p.getID}) is member of:"
  groups = {}; 
  DEPerson.groups(p).each { |p|  groups[p.getName] = p } 
  groups.keys.sort.each do |name|
    g = groups[name]
    puts ["\t","ID=#{g.getID}", name].join("\t")
  end
end

netids.each do |netid| 
    p = DEPerson.find(netid);
    if (p) then 
        print_members(p);
    else 
       puts "ERROR: EPERSON.#{netid} does not exist"
    end
   puts "";
end

