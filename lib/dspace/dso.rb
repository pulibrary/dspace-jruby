require 'json'

module DSO

  def initialize(dobj)
    raise "must pass non null obj" unless dobj
    type = DSpace.const_get self.class.name[1..-1].upcase
    @obj = dobj
    raise "#{dobj} is not a #{type} object" unless @obj.getType == type
  end

  def dso
    return @dso
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

