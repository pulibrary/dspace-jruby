class DCommunity < DSO

  def self.all()
    java_import org.dspace.content.Community;
    return Community.findAll(DSpace.context)
  end

  def self.findAll(name)
    java_import org.dspace.content.Community;
    self.all.select do |c|
      c.getName == name
    end
  end

  def self.report(dso)
    rpt = DSO.report(dso)
    if (!dso.nil?) then
      rpt[:name] = dso.getName();
      subs = dso.getSubcommunities();
      if (not subs.empty?) then
        rpt[:subcomunities] = {};
        subs.each do |sc|
          rpt[:subcomunities][sc.getName()] = DCommunity.report(sc);
        end
      end
      subs = dso.getCollections();
      if (not subs.empty?) then
        rpt[:collections] = {};
        subs.each do |sc|
          rpt[:collections][sc.getName()] = DCollection.report(sc);
        end
      end
    end
    return rpt;
  end

end
