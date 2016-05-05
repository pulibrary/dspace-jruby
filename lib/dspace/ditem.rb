class DItem
  include DSO;

  def self.iter
    java_import org.dspace.content.Item;
    Item.findAll(DSpace.context);
  end

  def self.all
    java_import org.dspace.content.Item;
    list = []
    stp = iter
    while (i = stp.next)
      list << i
    end
    return list
  end

  def self.find(id)
    java_import org.dspace.content.Item;
    id = id.to_i if id.class == String
    return Item.find(DSpace.context, id)
  end

  def self.inside(restrict_to_dso)
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow

    return [] if restrict_to_dso.nil?
    return [restrict_to_dso] if restrict_to_dso.getType == DSpace::ITEM
    return [] if restrict_to_dso.getType != DSpace::COLLECTION and restrict_to_dso.getType != DSpace::COMMUNITY

    sql = "SELECT ITEM_ID FROM ";
    if (restrict_to_dso.getType() == DSpace::COLLECTION) then
      sql = sql + "  Collection2Item CO WHERE  CO.Collection_Id = #{restrict_to_dso.getID}"
    else
      # must be COMMUNITY
      sql = sql + " Community2Item CO  WHERE CO.Community_Id = #{restrict_to_dso.getID}"
    end
    puts sql;

    tri = DatabaseManager.query(DSpace.context, sql)
    dsos = [];
    while (i = tri.next())
      item =  DSpace.find('ITEM', i.getIntColumn("item_id"))
      dsos << item
    end
    tri.close
    return dsos
  end

  def bitstreams(bundle = "ORIGINAL")
    bundle = @obj.getBundles.select { |b| b.getName() == bundle }[0]
    if (not bundle.nil?) then
      return bundle.getBitstreams
    end
    return [];
  end

  def self.install(collection, metadata_hash)
    java_import org.dspace.content.InstallItem;
    java_import org.dspace.content.WorkspaceItem;
    java_import org.dspace.content.Item;

    wi = WorkspaceItem.create(DSpace.context, collection, false)
    item = wi.getItem
    metadata_hash.each do |key,value|
      (schema, element,qualifier) = key.split('.')
      if (value.class == Array ) then
        value.each do |val|
          item.addMetadata(schema, element, qualifier, nil, val);
        end
      else
        item.addMetadata(schema, element, qualifier, nil, value);
      end
    end
    InstallItem.installItem(DSpace.context, wi);
    return item;
  end

end
