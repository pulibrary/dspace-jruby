# frozen_string_literal: true

module DSpace
  module Core
    ##
    # Class wrapper for org.dspace.content.MetadataField
    # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/MetadataField.java
    class MetadataField
      include ObjectBehavior

      ##
      # Get Metadatafield with given filters.
      #
      # @param fully_qualified_metadata_field [string] must follow format:
      #   schema.element[.qualifier]
      # @return [nil, org.dspace.content.MetadataField] the object with the given
      #   field name
      def self.find(fully_qualified_metadata_field)
        java_import org.dspace.content.MetadataSchema
        java_import org.dspace.content.MetadataField
        java_import org.dspace.storage.rdbms.DatabaseManager
        java_import org.dspace.storage.rdbms.TableRow

        (schema, element, qualifier) = fully_qualified_metadata_field.split('.')
        schm = MetadataSchema.find(DSpace.context, schema)
        raise "no such metadata schema: #{schema}" if schm.nil?

        MetadataField.find_by_element(DSpace.context, schm.getSchemaID, element, qualifier)
      end

      ##
      # Get full name of MetadataField
      #
      # @return [String] "nil" or <schema>.<element>[.<qualifier>]
      def fullName
        return 'nil' if @obj.nil?

        java_import org.dspace.content.MetadataSchema
        schema = MetadataSchema.find(DSpace.context, @obj.schemaID)
        str = "#{schema.getName}.#{@obj.element}"
        str += ".#{@obj.qualifier}" if @obj.qualifier
        str
      end

      ##
      # View string representation of object
      #
      # @return [String] string representation
      def inspect
        return 'nil' if @obj.nil?

        "#<#{self.class.name}:#{fullName}>"
      end
    end
  end
end
