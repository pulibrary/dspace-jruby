#!/usr/bin/env jruby  -I lib -I utils
require 'yaml';

test_data_file = "testdata.yml";
test_data = YAML.load_file(test_data_file);

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

def create_collections(parent, name)
  puts "Creating Collections #{name}\tin\t#{parent.getName}";
  new_col = Collection.create(DSpace.context)
  new_col.setMetadata("name", name)
  new_col.update
  parent.addCollection(new_col)
  puts "Created #{new_col.getHandle()}\t#{new_col.getName}"
end


require 'dspace'
DSpace.load()
java_import org.dspace.content.Collection
java_import org.dspace.content.Community

admin_user = DGroup.find(DGroup::ADMIN_ID).getMembers()[0]
puts "Using user account: #{admin_user.getEmail()}"
DSpace.context.setCurrentUser(admin_user)


test_data["communities"].each do |comm|
  parent_name = comm["name"];
  if parent_name then
    zap_community(parent_name)
    parent = create_community(parent_name)
    collections = comm["collections"];
    if (collections) then
      collections.each do |col|
        create_collections(parent, col["name"])
      end
    end
  end
end

DSpace.commit







