#!/usr/bin/env jruby  -I lib -I utils
require 'yaml';
require 'faker';

test_data_file = "testdata.yml";

def generate(file)
  test_data = YAML.load_file(file)
  test_data["communities"].each do |comm|
    parent_name = comm["name"];
    if parent_name then
      puts "zap_community #{parent_name}"
      zap_community(parent_name)
      parent = create_community(parent_name)
      puts "created #{parent.getHandle}\t#{parent.getName}"
      collections = comm["collections"];
      if (collections) then
        collections.each do |col|
          coll = create_collections(parent, col["name"])
          puts "created in #{parent.getName}\t#{coll.getHandle}\t#{coll.getName}\t"
          n = col["nitems"] || 0
          n.times do
            item = fake_item(coll)
            puts "created in #{parent.getName}\t#{coll.getHandle}\t#{coll.getName}\t#{item}"
          end
          puts "";
        end
      end
    end
  end
end

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
  new_col = Collection.create(DSpace.context)
  new_col.setMetadata("name", name)
  new_col.update
  parent.addCollection(new_col)
  return new_col;
end

def fake_item(col)
  return "item"
end


require 'dspace'
DSpace.load()
java_import org.dspace.content.Collection
java_import org.dspace.content.Community
java_import org.dspace.content.Item

admin_user = DGroup.find(DGroup::ADMIN_ID).getMembers()[0]
puts "Using user account: #{admin_user.getEmail()}"
DSpace.context.setCurrentUser(admin_user)

generate(test_data_file)
DSpace.commit







