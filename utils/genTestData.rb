#!/usr/bin/env jruby  -I lib -I utils
parent_name = "Faculty Publications"
coll_name_file = "collection_names.txt"

def zap_community(comm_name)
  DCommunity.findAll(comm_name).each do |c|
    c.delete();
  end
end

def create_community(comm_name)
  parent = Community.create(nil, DSpace.context)
  parent.setMetadata("name", comm_name)
  parent.update
  DSpace.commit
  return parent
end

def create_collections(parent, name_file)
  puts "Creating Collections in\t#{parent.getName}";

  File.open(name_file).each do |name|
    name = name.strip

    new_col = Collection.create(DSpace.context)
    new_col.setMetadata("name", name)
    new_col.update
    parent.addCollection(new_col)
    puts "Created #{new_col.getHandle()}\t#{new_col.getName}"
  end
end


require 'dspace'
DSpace.load()
java_import org.dspace.content.Collection
java_import org.dspace.content.Community

admin_user = DGroup.find(DGroup::ADMIN_ID).getMembers()[0]
puts "Using user account: #{admin_user.getEmail()}"
DSpace.context.setCurrentUser(admin_user)

zap_community(parent_name)
parent = create_community(parent_name)
create_collections(parent, coll_name_file)

DSpace.commit







