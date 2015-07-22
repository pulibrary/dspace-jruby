require 'json'

class DSO

  BITSTREAM = 0;
  BUNDLE = 1;
  ITEM = 2;
  COLLECTION = 3;
  COMMUNITY = 4;
  SITE = 5;
  GROUP = 6;
  EPERSON = 7;

  DSOCLASSES = [];

  def self.initialize
    puts "DOIT"
    DSOCLASSES[COMMUNITY] = DCommunity;
    DSOCLASSES[COLLECTION] = DCollection;
    DSOCLASSES[GROUP] = DGroup;
  end

  def initialize(dso)
    @dso = dso;
  end

  def self.report(dso)
    rpt = {};
    if (not dso.nil?) then
      rpt[:obj] = dso.toString()
      if (dso.getHandle()) then
        rpt[:handle] = dso.getHandle()
      end
    end
    return rpt;
  end

  def self.pretty_report(dso)
    rpt = {};
    if (not dso.nil? and DSOCLASSES[dso.getType()]) then
      rpt = DSO::DSOCLASSES[dso.getType()].send(:report, dso)
    else
      rpt = DSO.report(dso);
    end
    JSON::pretty_generate(rpt)
  end

  def self.fromString(type_id_or_handle)
    java_import org.dspace.content.DSpaceObject
    DSpaceObject.fromString(Dscriptor.context, type_id_or_handle)
  end

  def self.policies(dso)
    java_import org.dspace.authorize.AuthorizeManager
    pols = AuthorizeManager.getPolicies(Dscriptor.context, dso)
    pols.collect do |p|
      [p.getAction(), p.getEPerson, p.getGroup]
    end
  end

  def self.help
    if (self == DSO)
      klasses = ObjectSpace.each_object(Class).select { |c| c < DSO }
    else
      klasses = [ self ];
    end
    klasses << DSO
    klasses.each do |klass|
      klass.singleton_methods.sort.each do |mn|
        m = klass.method(mn)
        plist = m.parameters.collect { |p|
          if (p[0] == :req) then
            "#{p[1].to_s}"
          else
            "[ #{p[1].to_s} ]"
          end
        }
        puts "#{klass.name}.#{mn.to_s} (#{plist.join(", ")})"
      end
    end
    return nil
  end

end

