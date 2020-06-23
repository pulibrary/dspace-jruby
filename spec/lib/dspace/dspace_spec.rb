# NOTE: Error-prone, and rspec makes testing against DSpace difficult, skipping 
#   testing for now

describe DSpace do

  describe '.load' do
    before do 
      # TODO: Reset DSpace before each load
      #   DSpace.context.abort is a good start, but variables need to be reset as well
    end

    after :all do
      # TODO: Make sure DSpace is loaded properly for all tests
    end

=begin
The gem requires that DSpace.load work the first time. If an improper path is 
fed into .load, the user will need to restart the entire environment. Not all 
configurations and variables are reset when using .load more than once, and
.reload does not seem to work at all. Significant debugging is required to 
achieve the desired functionality.
=end

    it 'loads the DSpace kernel for the API' do
      dspace_dir_path = '/dspace'
      # expect { DSpace.load }.not_to raise_error
    end

    it 'throw error when given bad path' do
      bad_dspace_dir_path = '/foo/bar'
      # expect { DSpace.load }.to raise_error
    end
  end

  describe '.reload' do
    # See notes under .load
  end

  describe '.objTypeStr' do
  # Retrieve the Class modeling the internal DSpace Object using a string or integer constant for the resource ID
  # @param type_str_or_int [String]
  # @return [Object]
  #
  # @note type_str_or_int must be one of the following constant values: BITTREAM or EPERSON, or the corresponding string for these constants
  end

  describe '.objTypeId' do
  # Convert a String to an internal DSpace constant for resolving resource type
  # @param type_str_or_int [String]
  # @return [Integer]
  end

  describe '.context' do
  # Accesses the global context for interfacing with the DSpace kernel
  # @raise [StandardError]
  # @return [org.dspace.core.Context]
  end

  describe '.context_renew' do
  # Resets the current context used for interfacing with the DSpace kernel
  # @note this *will* ensure that all changes which have not been committed to the database will be lost
  # @raise [StandardError]
  # @return [org.dspace.core.Context]
  end

  describe '.login' do
  # Sets the current user for this session of working with the DSpace kernel
  # @note this is necessary in order to provide admin. access for modifying DSpace Objects
  # @param [String] netid the institutional NetID used to find the user account for the login
  end

  describe '.commit' do
  # Commit changes to the database for the current DSpace installation
  # @see Context.commit
  end

  describe '.create' do
  # Construct one of the wrapper Objects from one of the internal DSpace Objects
  # @raise [StandardError]
  # @return [org.dspace.content.DSpaceObject]
  end

  describe '.inspect' do
  # Construct and inspect a DSpace Object
  # @param dso [org.dspace.content.DSpaceObject]
  # @return [String]
  # @see org.dspace.content.DSpaceObject#inspect
  end

  describe '.find' do
  # Method for retrieving a DSpace object by the resource type and internal ID
  # @param type_id_or_handle_or_title [String]
  # @param identifier [String]
  # @return [org.dspace.content.DSpaceObject]
  # @example
  #   DSpace.find
  #   DSpace.find
  #   DSpace.find
  #   DSpace.find
  #
  # @note type_str_or_int must be be of the integer values BITTREAM and EPERSON, or the corresponding string
  # @note identifier must be an integer or string value uniquely identifying the object
  end

  describe '.fromString' do
  # Method for retrieving a DSpace object by the internal ID, Handle, or title
  # @param type_id_or_handle_or_title [String]
  # @return [org.dspace.content.DSpaceObject]
  end

  describe '.getServiceManager' do
  # Access the service manager for the DSpace kernel
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-services/src/main/java/org/dspace/servicemanager/DSpaceServiceManager.java
  # @return [org.dspace.servicemanager.DSpaceServiceManager]
  end

  describe '.getService' do
  # Access a service object registered with the DSpace kernel
  # This follows the enterprise design pattern: https://en.wikipedia.org/wiki/Service_locator_pattern
  # This is primarily used for interfacing indirectly with external services integrated with DSpace 
  # @see 
  end

  describe '.getIndexService' do
  # Access the SolrServiceImpl object
  # This is primarily used for interfacing directly with the underlying Apache Solr installation
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/discovery/SolrServiceImpl.java
  # @return [org.dspace.discovery.SolrServiceImpl]
  end

  describe '.findByMetadataValue' do
  # Queries the DSpace database for DSpace Communities, Collections, and Items which fall within a user-defined resource policy
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/DSpaceObject.java
  # @see [org.dspace.content.DSpaceObject]
  # @param fully_qualified_metadata_field [String] the metadata field used for the query 
  # @param value_or_nil [String] the value for the metadata field in the query
  # @param restrict_to_type [String] the type of resource
  # @return [org.dspace.content.DSpaceObject] the DSpace Objects
  #
  # @note restrict_to_type must be one of BITSTREAM or EPERSON
  # @note if value_or_nil is nil and restrict_to_type is nil, this will return all DSpaceObjects with the value for the given metadata field
  # @note if value_or_nil is not nil, this will restrict to those DSpace Objects which have metadata field values requal to the value
  # @note if restrict_to_typ is not nil, this will restrict to results to the provided resource type
  end

  describe '.findByGroupPolicy' do
  # Queries the DSpace database for DSpace Communities, Collections, and Items which fall within a user-defined resource policy
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/DSpaceObject.java
  # @return [org.dspace.content.DSpaceObject]
  end

  describe '.help' do
  # Provides documentation using STDOUT for the methods on the DSpace Classes
  # print available static methods for the give classes
  end

end
