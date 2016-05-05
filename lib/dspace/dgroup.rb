class DGroup
  include DSO

  ADMIN_ID = 1;
  ANONYMOUS_ID = 0;

  def self.all
    java_import org.dspace.eperson.Group;
    Group.findAll(DSpace.context, 1);
  end

  def self.find(name_or_id)
    java_import org.dspace.eperson.Group;
    if (name_or_id.class == String)
      return Group.findByName(DSpace.context, name_or_id);
    else
      return Group.find(DSpace.context, name_or_id)
    end
  end

  def self.find_or_create(name)
    raise "must give a name " unless name
    group = self.find(name);
    if (group.nil?) then
      group = Group.create(DSpace.context);
      group.setName(name)
      group.update();
      puts "Created #{group.toString()}"
    else
      puts "Exists #{group.toString()}"
    end
    return group;
  end

  def members
    list = [];
    @obj.getMembers.each do |m|
      list << m;
    end
    @obj.getMemberGroups.each do |m|
      list << m;
    end
    return list;
  end

  def addMember(group_or_eperson)
    raise "must give non nil group_or_eperson" if group_or_eperson.nil?
    @obj.addMember(group_or_eperson);
    @obj.update
    return @obj;
  end

  def report
    rpt = dso_report
    @obj.getMemberGroups.each do |m|
      rpt[m.toString] = DGroup.new(m).report
    end
    list = @obj.getMembers()
    rpt['epersons'] = list.collect { |p| DEerson.new(p).report  } unless list.empty?
    return rpt;
  end

end
