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
  groups = DEPerson.groups(p).collect { |p| p.getName } 
  groups.sort.each do |name|
    puts "\t" + name
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

