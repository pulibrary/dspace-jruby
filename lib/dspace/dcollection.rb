class DCollection < DSO

  def self.all()
    java_import org.dspace.content.Collection;
    return Collection.findAll(Dscriptor.context)
  end

  def self.findAll(name)
    java_import org.dspace.content.Collection;
    self.all.select do |c|
      c.getName == name
    end
  end

  def self.report(dso)
    rpt = DSO.report(dso)
    if (!dso.nil?) then
        rpt[:name]  = dso.getName();
        group = dso.getSubmitters();
        rpt[:submitters] = DGroup.report(group);
        [1,2,3].each do |i|
          group = dso.getWorkflowGroup(i);
          if (group) then
            rpt[ "workflow_group_#{i}".to_sym] = DGroup.report(group);
          end
        end
    end
    return rpt;
  end
end