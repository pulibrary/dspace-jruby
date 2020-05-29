describe DDSpaceObject do
  describe '#parents' do
  ##
  # Collect all parents, grandparents, etc. from Dspace object
  #
  # @return [Array<DSO>] All parent objects
  end

  describe '#isInside' do
  ##
  # Determine if object is within given Dspace object
  #
  # @param dobj [DSO] the Dspace object in question
  # @return [Boolean] is the parameter a parent of our object?
  end

  describe '#policies' do
      ##
  # Collect all the policies from Dspace object
  #
  # @return [Array<Hash>] an array of policies, defined by Action, Eperson, and Group
  end

  describe '#getMetaDataValues' do
  ##
  # Collect all metadata from Dspace object
  #
  # @return [Array<DMetadataField, String>] Metadata object and metadata name.
  end

end
