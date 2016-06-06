##
# This module contains methods to be included by classes that wrap objects 
# that derive from org.dspace.content.DSpaceObject 
require 'json'

module DSO

  ## 
  # instanciates a wrapper object for the given dobj, which must derive from org.dspace.content.DSpaceObject
  # 
  # the wrapper object's class must be compatible with the type of the given dobj 
  def initialize(dobj)
    raise "must pass non null obj" unless dobj
    type = DConstants.const_get self.class.name[1..-1].upcase
    @obj = dobj
    raise "#{dobj} is not a #{type} object" unless @obj.getType == type
  end

  def dso
    return @obj
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

  def policies()
    java_import org.dspace.authorize.AuthorizeManager
    pols = AuthorizeManager.getPolicies(DSpace.context, @obj)
    pols.collect do |p|
      pp = p.getEPerson
      pg = p.getGroup
      hsh = { :action => p.getAction()}
      hsh[:person] = pp.getName if pp
      hsh[:group] = pg.getName if pg
      hsh
    end
  end

  def getMetaDataValues()
    java_import org.dspace.content.MetadataSchema
    java_import org.dspace.content.MetadataField
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow

    sql = "SELECT MV.metadata_field_id,  MV.text_value FROM METADATAVALUE MV " +
            " WHERE RESOURCE_TYPE_ID = #{@obj.getType} AND RESOURCE_ID = #{@obj.getID}"
    tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue",   sql)
    mvs = [];
    while (iter = tri.next())
      field =  MetadataField.find(DSpace.context, iter.getIntColumn("metadata_field_id"))
      mvs <<  [ DMetadataField.new(field), iter.getStringColumn("text_value") ]
    end
    tri.close
    return mvs
  end

  def inspect
    return "nil" if @obj.nil?
    return "#{@obj.getTypeText}.#{@obj.getID}"
  end

end

