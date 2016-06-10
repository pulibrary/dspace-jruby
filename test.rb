require 'dspace'
DSpace.load

def test_dso(ddso)
  [:policies, :parents, :getMetaDataValues].each do |m|
    puts "#{ddso.inspect}.#{m} -> #{ddso.send(m)}"
  end
end

[DCommunity, DCollection, DItem, DBitstream].each do |klass|
  puts klass.name + ".all"
  all = klass.send :all
  dso = all[0]
  puts klass.name + ".find"
  o = klass.send :find, dso.getID
  ddso = DSpace.create(o)
  puts "ddso.inspect #{ddso.inspect}"

  o = DSpace.fromString("#{DConstants.typeStr(dso.getType)}.#{dso.getID}")
  puts "ERROR #{o} != #{DSpace.create(dso).inspect}" if o != dso
  if dso.getHandle then
    o = DSpace.fromString(dso.getHandle)
    puts "ERROR #{o} != #{DSpace.create(dso).inspect}" if o != dso
  end

  test_dso(ddso)
end

[DWorkflowItem, DWorkspaceItem].each do |klass|
  puts klass.name + ".findAll"
  all = klass.send :findAll, nil
  id = all.length > 0 ? all[0].getID : nil
  puts klass.name + ".find #{id}"
  obj = klass.send(:find, id)
  puts "#{klass}.new #{obj}"
  puts klass.send(:new, obj).inspect
end

ditem = DSpace.create(DBitstream.all[0].getParentObject)
puts "#{ditem}.bitstreams => #{ditem.bitstreams}"
bundle = ditem.bitstreams[0].getBundles[0]
puts bundle
dbundle = DSpace.create(bundle)
test_dso(dbundle)

