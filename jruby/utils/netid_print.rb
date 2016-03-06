#!/usr/bin/env jruby -I lib
require 'optparse'
require 'dspace'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__}   netid.."
end

netids = ARGV
if netids.empty? then
   parser.help
end

DSpace.load

def print_members(p)
  puts "#{p.getNetid} (ID=#{p.getID}) is member of:"
  groups = {};
  DSpace.create(p).groups.each { |g|  groups[g.getName] = g }
  groups.keys.sort.each do |name|
    g = groups[name]
    puts ["\t","ID=#{g.getID}", name].join("\t")
  end
end

netids.each do |netid| 
    p = DEPerson.find(netid);
    if (p) then 
      print_members(p)
    else 
       puts "ERROR: EPERSON.#{netid} does not exist"
    end
   puts "";
end

