class DItem
  include DSO;

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
