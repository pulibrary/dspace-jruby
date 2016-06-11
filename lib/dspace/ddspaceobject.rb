##
# This module contains methods to be included by classes that wrap objects 
# that derive from org.dspace.content.DSpaceObject 
require 'json'

module DDSpaceObject

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

end

