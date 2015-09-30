#!/usr/bin/env jruby -I lib
require "highline/import"
require 'dspace'

netid, first, last = ARGV
netid = ask("enter netid ") unless netid
first = ask("first name  ") unless first
last = ask("last name  ") unless last

admin = ENV["USER"]
puts admin

DSpace.load
DSpace.login(admin)

doit = ask "create #{netid} for first: #{first} and last #{last} ? (Y/N) "
if (doit == "Y") then
  p = DEPerson.find(netid)
  if p.nil? then
    p = DEPerson.create(netid, first, last)
    doit = ask "commit ? (Y/N) "
    if (doit == "Y")
      DSpace.commit
    end
  else
    puts "Exists #{p.toString()}"
  end


end 


