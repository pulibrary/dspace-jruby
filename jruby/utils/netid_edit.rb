#!/usr/bin/env jruby -I lib
require "highline/import"
require 'dspace'
DSpace.load


def print_members(p)
  puts "#{p} is member of:"
  groups = DEPerson.groups(p).collect { |p| p.getName } 
  groups.sort.each do |name|
    puts "\t" + name
  end
  puts "";
end

netid = ask "enter netid "
p = DEPerson.find(netid);
raise "no such eperson" if p.nil?
print_members(p);

yes = ask "want to add to same groups as another user ? [Y/N] "
if (yes == "Y") then
  who = ask "who ? [enter netid] "
  o = DEPerson.find(who);
  raise "no such eperson" if o.nil?
  print_members(o);
  pgroups = DEPerson.groups(p)
  DEPerson.groups(o).each do |g|
    if (pgroups.select { |pg| pg.getName() == g.getName }.empty?) then
      yes = ask "add #{p} to #{g.getName()} ? [Y/N] ";
      if (yes == "Y") then
        puts "\tadding #{p} to #{g}"
        g.addMember(p);
        g.update();
      end
    else
      puts "\talready member of #{g}"
    end
  end
end
puts "";


yes = ask "want to remove from groups ? [Y/N] "
if (yes == "Y") then
  DEPerson.groups(p).each do |g|
    yes = ask "remove #{p} from #{g.getName()} ? [Y/N] ";
    if (yes == "Y") then
      puts "\tremoving from #{g}"
      g.removeMember(p);
      g.update();
    end
  end
end
puts "";

print_members(p);
yes = ask "want to commit the changes ? [Y/N] "
if (yes == "Y") then
  DSpace.commit
end
