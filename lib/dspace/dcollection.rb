class DCollection
  include DSO

  def self.all()
    java_import org.dspace.content.Collection;
    return Collection.findAll(DSpace.context)
  end

  def self.find(id)
    java_import org.dspace.content.Collection;
    return Collection.find(DSpace.context, id)
  end


  def self.findAll(name)
    java_import org.dspace.content.Collection;
    self.all.select do |c|
      c.getName == name
    end
  end

  def report()
    rpt = dso_report
    rpt[:name] = @obj.getName();
    group = @obj.getSubmitters();
    rpt[:submitters] = DGroup.new(group).report if group
    [1, 2, 3].each do |i|
      group = @obj.getWorkflowGroup(i);
      if (group) then
        rpt["workflow_group_#{i}".to_sym] = DGroup.new(group).report;
      end
    end
    return rpt;
  end
end