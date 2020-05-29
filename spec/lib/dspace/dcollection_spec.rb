describe DCollection do

  describe '.all' do
  ##
  # Collect all Collection objects from Dspace context
  # 
  # @return [Array<org.dspace.content.Collection>] all Collections
  end

  describe '.find' do
##
  # Get corresponding Collection object from a given id
  #
  # @param id [Integer] the Collection id
  # @return [nil, org.dspace.content.Collection] either the corresponding 
  #   collection object or nil if it couldn't be found.
  end

  describe '.create' do
  ##
  # Create and return org.dspace.content.Collection with given name in the 
  #   given community
  #
  # @param name [String] the name of the new collection
  # @param community [org.dspace.content.Communiy] the community the collection 
  #   should be placed within
  # @return [org.dspace.content.Collection] the newly created collection
  end

  describe '#items' do
  ##
  # Return all items listed by the dspace item iterator
  # 
  # @return [Array<org.dspace.content.Item>] an array of Item objects
  end
end
