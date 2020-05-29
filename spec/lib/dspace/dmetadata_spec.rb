describe DMetadataSchema do
  describe '.all' do
  ##
  # Get all MetaDataSchema within Dspace context
  #
  # @return [Array<org.dspace.content.MetadataSchema>] All schemas
  end

  describe '#fields' do
  ##
  # Get all MetaDatafields within Dspace context
  #
  # @return [Array<org.dspace.content.MetadataField>] All fields
  end

  describe '#inspect' do
  ##
  # View string representation of object
  #
  # @return [String] string representation
  end
end

## ------------

describe DMetadataField do
  describe '.find' do
  ##
  # Get Metadatafield with given filters.
  #
  # @param fully_qualified_metadata_field [string] must follow format:
  #   schema.element[.qualifier]
  # @return [nil, org.dspace.content.MetadataField] the object with the given
  #   field name
  end

  describe '#fullName' do
    ##
  # Get full name of MetadataField
  #
  # @return [String] "nil" or <schema>.<element>[.<qualifier>]
  end

  describe '#inspect' do
  ##
  # View string representation of object
  #
  # @return [String] string representation
  end

end
