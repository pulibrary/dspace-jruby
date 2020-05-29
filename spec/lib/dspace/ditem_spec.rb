##
# This class wraps an org.dspace.content.Item object
describe DItem do
  describe '.iter' do
##
  # Iterate through all Items in Dspace context
  # 
  # @return [org.dspace.content.ItemIterator<org.dspace.content.Item>] iterator
  end

  describe '.all' do
  ##
  # Collect array of all archived org.dspace.content.Item objects

  # @return [Array<org.dspace.content.Item>] array of Items
  end

  describe '.find' do
      ##
  # Get corresponding Item object from a given id
  #
  # @param id [Integer] the Item id
  # @return [nil, org.dspace.content.Item] either the corresponding 
  #   collection object or nil if it couldn't be found.
  end

  describe '.inside' do
  ##
  # returns [] if restrict_to_dso is nil or all items that are contained in the given restrict_to_dso
  #
  # @param restrict_to_dso [nil, org.dspace.content.Item, 
  #   org.dspace.content.Collection, org.dspace.content.Community] restrictions
  #   on search
  end

  describe '#bitstreams' do
  ##
  # Get the bitstreams in the given bundle.
  # 
  # @param bundle [String] bundle to search; if nil, get all.
  # @return [Array<org.dspace.content.Bitstream>] All bitstream 
  end

  describe '.install' do
  ##
  # Creata a org.dspace.content.Item with the given metadata in the given 
  #   collection.
  #
  # @param collection [org.dspace.content.Collection] Collection in which to 
  #   place the Item.
  # @param metadata_hash [Hash] Item's metadata. (contains keys like 
  #   dc.contributir.author and single string or arrays of values)
  end

end
