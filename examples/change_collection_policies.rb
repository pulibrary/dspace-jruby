#!/usr/bin/env jruby

require 'dspace'

DSpace.load
context = DSpace.context;

c = DCollection.fromString('116099117/236')

anon = DGroup.find("Anonymous")
AuthorizeManager.remove_all_policies(context, c)
AuthorizeManager.add_policy(context, c, Constants::READ, anon)
c.update

c.items.each do |iten|
  AuthorizeManager.remove_all_policies(context, item)
  AuthorizeManager.inherit_policies(context, c, item)
  item.update
end

puts "should do context.comit to push changes to database"


