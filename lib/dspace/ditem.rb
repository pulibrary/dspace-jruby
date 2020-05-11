##
# This class wraps an org.dspace.content.Item object
class DItem
  include DSO;
  include DDSpaceObject

  ##
  # Iterate through all Items in Dspace context
  # 
  # @return [org.dspace.content.ItemIterator<org.dspace.content.Item>] iterator
  def self.iter
    java_import org.dspace.content.Item;
    Item.findAll(DSpace.context);
  end

  ##
  # Collect array of all archived org.dspace.content.Item objects

  # @return [Array<org.dspace.content.Item>] array of Items
  def self.all()
    java_import org.dspace.content.Item;
    list, stp = [], iter
    while (i = stp.next)
      list << i
    end
    return list
  end

  ##
  # Get corresponding Item object from a given id
  #
  # @param id [Integer] the Item id
  # @return [nil, org.dspace.content.Item] either the corresponding 
  #   collection object or nil if it couldn't be found.
  def self.find(id)
    java_import org.dspace.content.Item;
    return Item.find(DSpace.context, id)
  end

  ##
  # returns [] if restrict_to_dso is nil or all items that are contained in the given restrict_to_dso
  #
  # @param restrict_to_dso [nil, org.dspace.content.Item, 
  #   org.dspace.content.Collection, org.dspace.content.Community] restrictions
  #   on search
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
  # Get the bitstreams in the given bundle.
  # 
  # @param bundle [String] bundle to search; if nil, get all.
  # @return [Array<org.dspace.content.Bitstream>] All bitstream 
  def bitstreams(bundle = "ORIGINAL")
    bundles = bundle.nil? ? @obj.getBundles : @obj.getBundles(bundle)
    bits = []
    bundles.each do |b|
      bits += b.getBitstreams
    end
    bits
  end

  ##
  # Creata a org.dspace.content.Item with the given metadata in the given 
  #   collection.
  #
  # @param collection [org.dspace.content.Collection] Collection in which to 
  #   place the Item.
  # @param metadata_hash [Hash] Item's metadata. (contains keys like 
  #   dc.contributir.author and single string or arrays of values)
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
