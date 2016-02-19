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
    DSOCLASSES[COMMUNITY] = DCommunity;
    DSOCLASSES[COLLECTION] = DCollection;
    DSOCLASSES[GROUP] = DGroup;
  end

  def initialize(dso)
    @dso = dso;
  end

  def self.fromHandle(handle)
    java_import org.dspace.content.DSpaceObject
    java_import org.dspace.handle.HandleManager;
    return HandleManager.resolve_to_object(DSpace.context, handle);
  end

  def self.fromString(type_id_or_handle)
    java_import org.dspace.content.DSpaceObject
    DSpaceObject.fromString(DSpace.context, type_id_or_handle)
  end

  def self.find(type, id)
    java_import org.dspace.core.Constants
    self.fromString("#{Constants.typeText[type]}.#{id}")
  end

  def self.items(restrict_to_dso)
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow

    return [] if restrict_to_dso.nil?
    return [restrict_to_dso] if restrict_to_dso.getType == ITEM
    return [] if restrict_to_dso.getType != COLLECTION and restrict_to_dso.getType != COMMUNITY

    sql = "SELECT ITEM_ID FROM ";
    if (restrict_to_dso.getType() == COLLECTION) then
      sql = sql + "  Collection2Item CO WHERE  CO.Collection_Id = #{restrict_to_dso.getID}"
    else
      # must be COMMUNITY
      sql = sql + " Community2Item CO  WHERE CO.Community_Id = #{restrict_to_dso.getID}"
    end
    # puts sql;

    tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue",   sql)
    dsos = [];
    while (i = tri.next())
      item =  self.find(DSO::ITEM, i.getIntColumn("item_id"))
      dsos << item
    end
    tri.close
    return dsos
  end

  def self.findByHandelQuery(sql)
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow
    #sql = "SELECT H.HANDLE, M.TEXT_VALUE FROM HANDLE H JOIN METADATAVALUE M ON M.ITEM_ID = H.RESOURCE_ID WHERE M.METADATA_FIELD_ID = 82 AND M.TEXT_VALUE  LIKE '2014%'"
    sql = "SELECT HANDLE FROM HANDLE WHERE ROWNUM < 10";

    tri = DatabaseManager.queryTable(DSpace.context, "Handle",   sql)

    dsos = [];
    while (row = tri.next())
      dsos << self.fromString(row.getStringColumn("handle"))
    end

    tri.close
    return dsos
  end

  def self.parents(dso)
    moms = [];
    p = dso.getParentObject()
    while p do
      moms << p;
      p = p.getParentObject();
    end
    return moms;
  end

  def self.report(dso)
    rpt = {};
    if (not dso.nil?) then
      rpt[:obj] = dso.toString()
      if (dso.getHandle()) then
        rpt[:handle] = dso.getHandle()
      end
      if (dso.getParentObject()) then
        rpt[:parent] = dso.getParentObject().to_s
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
  end

  def self.policies(dso)
    java_import org.dspace.authorize.AuthorizeManager
    pols = AuthorizeManager.getPolicies(DSpace.context, dso)
    pols.collect do |p|
      [p.getAction(), p.getEPerson, p.getGroup]
    end
  end

  def self.bitstreams(dso, bundle = "ORIGINAL")
    if (dso.getType() == ITEM)
      bundle = item.getBundles.select { |b|  b.getName() == bundle }[0]
      if (not bundle.nil?) then
        return bundle.getBitstreams
      end
    else
      return [];
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

