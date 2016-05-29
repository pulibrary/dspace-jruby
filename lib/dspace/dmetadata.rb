class DMetadataField

  ##
  # instantiate a wrapper for the given org.dspace.content.MetadataField
  def initialize(dobj)
    raise "must pass non null obj" unless dobj
    raise "must pass org.dspace.content.MetadataField obj" unless dobj.instance_of? org.dspace.content.MetadataField
    @obj = dobj
  end

  ##
  # returns nil or the org.dspace.content.MetadataField object with the given field_name
  # field_name:: must be an string foemmated as   schema.element[.qualifier]
  def self.find(fully_qualified_metadata_field)
    java_import org.dspace.content.MetadataSchema
    java_import org.dspace.content.MetadataField
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow

    (schema, element, qualifier) = fully_qualified_metadata_field.split('.')
    schm = MetadataSchema.find(DSpace.context, schema)
    raise "no such metadata schema: #{schema}" if schm.nil?
    return MetadataField.find_by_element(DSpace.context, schm.getSchemaID, element, qualifier)
  end

  def inspect
    java_import org.dspace.content.MetadataSchema
    schema = MetadataSchema.find(DSpace.context, @obj.schemaID)
    str = "#{schema.getName}.#{@obj.element}"
    str += ".#{@obj.qualifier}" if @obj.qualifier
    return str
  end

end
