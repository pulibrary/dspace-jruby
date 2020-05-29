describe DCommunity do
  describe '.all' do
  ##
  # Collect all Community objects from Dspace context
  #
  # @return [Array<org.dspace.content.Community>]
  end

  describe '.find' do
  ##
  # Get corresponding Community object from a given id
  #
  # @param id [Integer] the Community id
  # @return [nil, org.dspace.content.Community] either the corresponding
  #   Community object or nil if it couldn't be found.
  end

  describe '.create' do
   ##
  # Create and return org.dspace.content.Community with given name in the given
  #   community
  #
  # @param name [String] the name of the new Community
  # @return [org.dspace.content.Community] the newly created Community
  end

  describe '#getCollections' do
  # Retrieve all child Collections and Collections within Sub-Communities for this object
  # @return [Array<org.dspace.context.Collections>]
  end

  describe '.getCollections' do
  # Get all collections from within given community and subcommunities
  #
  # @param com [org.dspace.content.Community]
  # @return [Array<org.dspace.content.Collection>]
  end
end
