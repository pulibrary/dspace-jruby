require 'json'

module DSO

  def initialize(dobj)
    raise "must pass null null obj" unless dobj
    raise "object is not a Java::OrgDspace object" unless dobj.class.to_s.start_with?("Java::OrgDspace")
    @obj = dobj
  end

  def parents
    moms = [];
    p = @obj.getParentObject()
    while p do
      moms << p;
      p = p.getParentObject();
    end
    return moms;
  end

  def dso_report
    rpt = {};
    rpt[:name] = @obj.getName
    rpt[:obj] = @obj.toString()
    if (@obj.getHandle()) then
      rpt[:handle] = @obj.getHandle()
    end
    if (@obj.getParentObject()) then
      rpt[:parent] = @obj.getParentObject().to_s
    end
    return rpt;
  end

  def report
    dso_report
  end

  def policies()
    java_import org.dspace.authorize.AuthorizeManager
    pols = AuthorizeManager.getPolicies(DSpace.context, @obj)
    pols.collect do |p|
      [p.getAction(), p.getEPerson, p.getGroup]
    end
  end

end

