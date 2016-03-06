class DCommunity
  include DSO

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

  def report
    rpt = dso_report
    list =  @obj.getSubcommunities.collect {|sc| DCommunity.new(sc).report }
    rpt[:subcomunities] = list unless list.empty?
    list =  @obj.getCollections.collect {|sc| DCollection.new(sc).report }
    rpt[:collections] = list unless list.empty?
    return rpt;
  end

end
