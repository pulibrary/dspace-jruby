##
# This class wraps an org.dspace.content.Item object
class DItem
  include DSO;
  include DDSpaceObject

  ##
  # return org.dspace.content.ItemIterator for all Items
  def self.iter
    java_import org.dspace.content.Item;
    Item.findAll(DSpace.context);
  end

  ##
  # return array of all org.dspace.content.Item objects
  def self.all()
    java_import org.dspace.content.Item;
    list, stp = [], iter
    while (i = stp.next)
      list << i
    end
    return list
  end

  ##
  # returns nil or the org.dspace.content.Item object with the given id
  #
  # id must be an integer
  def self.find(id)
    java_import org.dspace.content.Item;
    return Item.find(DSpace.context, id)
  end

  ##
  # returns [] if restrict_to_dso is nil or all items that are contained in the given restrict_to_dso
  #
  # restrict_to_dso must be nil, or an instance of org.dspace.content.Item, Collection, or Community
  def self.inside(restrict_to_dso)
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow

    return [] if restrict_to_dso.nil?
    return [restrict_to_dso] if restrict_to_dso.getType == DConstants::ITEM
    return [] if restrict_to_dso.getType != DConstants::COLLECTION and restrict_to_dso.getType != DConstants::COMMUNITY

    sql = "SELECT ITEM_ID FROM ";
    if (restrict_to_dso.getType() == DConstants::COLLECTION) then
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

  ##
  # returns the bitstreams in the given bundle
  def bitstreams(bundle = "ORIGINAL")
    bundles = bundle.nil? ? @obj.getBundles : @obj.getBundles(bundle)
    bits = []
    bundles.each do |b|
      bits += b.getBitstreams
    end
    bits
  end

  ##
  # creata a org.dspace.content.Item with the given metadata in the given collection
  #
  # metadata_hash use keys like dc.contributir.author and single string or arrays of values
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
