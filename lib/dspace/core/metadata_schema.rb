# frozen_string_literal: true

module DSpace
  module Core
    ##
    # Class wrapper for org.dspace.content.MetadataSchema
    # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/MetadataSchema.java
    class MetadataSchema
      java_import(org.dspace.content.MetadataSchema)

      include ObjectBehavior

      ##
      # Get all MetaDataSchema within Dspace context
      #
      # @return [Array<org.dspace.content.MetadataSchema>] All schemas
      def self.all
        MetadataSchema.findAll DSpace.context
      end

      ##
      # Get all MetaDatafields within Dspace context
      #
      # @return [Array<org.dspace.content.MetadataField>] All fields
      def fields
        java_import org.dspace.content.MetadataField
        MetadataField.findAllInSchema(DSpace.context, @obj.getSchemaID)
      end

      ##
      # View string representation of object
      #
      # @return [String] string representation
      def inspect
        return 'nil' if @obj.nil?

        "#<#{self.class.name}:#{@obj.getName}>"
      end
    end
  end
end
