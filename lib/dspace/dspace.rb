# Module providing interfaces for interfacing with the DSpace kernel
module DSpace
  ROOT = File.expand_path('../..', __FILE__)
  @@config = nil;

  # Retrieve the Class modeling the internal DSpace Object using a string or integer constant for the resource ID
  # @param type_str_or_int [String]
  # @return [Object]
  #
  # @note type_str_or_int must be one of the following constant values: BITTREAM or EPERSON, or the corresponding string for these constants
  def self.objTypeStr(type_str_or_int)
    if type_str_or_int.class == String and Constants.typeText.find_index type_str_or_int.upcase then
      klassName = type_str_or_int.capitalize
    else
      begin
        id = Integer(type_str_or_int)
      rescue
        raise "no such object type #{type_str_or_int}"
      end
      klassName = DConstants.typeStr(id)
    end
    return "EPerson" if klassName == "Eperson"
    return klassName
  end

  # Convert a String to an internal DSpace constant for resolving resource type
  # @param type_str_or_int [String]
  # @return [Integer]
  def self.objTypeId(type_str_or_int)
    obj_typ = Constants.typeText.find_index objTypeStr(type_str_or_int).upcase
  end

  # Initialize the DSpace kernel by searching within directory for the DSpace installation
  # @param dspace_dir [String]
  # @note if dspace_dir is nil, this will use the value of the environment variable $DSPACE_HOME
  # @note if $DSPACE_HOME is undefined also, it will then default to '/dspace'
  def self.load(dspace_dir = nil)
    if (@@config.nil?) then
      @@config = Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
      self.context # initialize context now
      java_import org.dspace.handle.HandleManager;
      java_import org.dspace.core.Constants
      java_import org.dspace.content.DSpaceObject
    end
    if (@@config)
      @@config.print
    end
    return @@config != nil
  end

  # Reinitialize the DSpace kernel by searching within directory for the DSpace installation
  # @param dspace_dir [String]
  # @note if dspace_dir is nil, this will use the value of the environment variable $DSPACE_HOME
  # @note if $DSPACE_HOME is undefined also, it will then default to '/dspace'
  def self.reload(dspace_dir = nil)
    @@config = nil
    load(dspace_dir)
  end

  # Accesses the global context for interfacing with the DSpace kernel
  # @raise [StandardError]
  # @return [org.dspace.core.Context]
  def self.context
    raise "must call load to initialize" if @@config.nil?
    raise "should never happen" if @@config.context.nil?
    return @@config.context
  end

  # Resets the current context used for interfacing with the DSpace kernel
  # @note this *will* ensure that all changes which have not been committed to the database will be lost
  # @raise [StandardError]
  # @return [org.dspace.core.Context]
  def self.context_renew
    raise "must call load to initialize" if @@config.nil?
    raise "should never happen" if @@config.context.nil?
    return @@config.context_renew
  end

  # Sets the current user for this session of working with the DSpace kernel
  # @note this is necessary in order to provide admin. access for modifying DSpace Objects
  # @param [String] netid the institutional NetID used to find the user account for the login
  def self.login(netid)
    self.context.setCurrentUser(DEPerson.find(netid))
    return nil
  end

  # Commit changes to the database for the current DSpace installation
  # @see Context.commit
  def self.commit
    self.context.commit
  end

  # Construct one of the wrapper Objects from one of the internal DSpace Objects
  # @raise [StandardError]
  # @return [org.dspace.content.DSpaceObject]
  def self.create(dso)
    raise "dso must not be nil" if dso.nil?
    klass = Object.const_get "D" + dso.class.name.gsub(/.*::/, '')
    klass.send :new, dso
  end

  # Construct and inspect a DSpace Object
  # @param dso [org.dspace.content.DSpaceObject]
  # @return [String]
  # @see org.dspace.content.DSpaceObject#inspect
  def self.inspect(dso)
    dso = DSpace.create(dso) if dso
    dso.inspect
  end

  # Method for retrieving a DSpace object by the resource type and internal ID
  # @param type_id_or_handle_or_title [String]
  # @param identifier [String]
  # @return [org.dspace.content.DSpaceObject]
  # @example
  #   DSpace.find(DSpace::COLLECTION, 106)
  #   DSpace.find("ITEM", 10)
  #   DSpace.find("GROUP", "Anonymous")
  #   DSpace.find("EPERSON", "her@there.com")
  #
  # @note type_str_or_int must be be of the integer values BITTREAM and EPERSON, or the corresponding string
  # @note identifier must be an integer or string value uniquely identifying the object
  def self.find(type_str_or_int, identifier)
    type_str = DSpace.objTypeStr(type_str_or_int)
    type_id = DSpace.objTypeId(type_str)
    klass = Object.const_get "D" + type_str
    begin
      id = Integer(identifier)
    rescue
      id = identifier
    end
    return klass.send :find, id
  end

  # Method for retrieving a DSpace object by the internal ID, Handle, or title
  # @param type_id_or_handle_or_title [String]
  # @return [org.dspace.content.DSpaceObject]
  def self.fromString(type_id_or_handle_or_title)
    #TODO handle MetadataField string
    if type_id_or_handle_or_title.start_with? 'TITLE' then
      str = type_id_or_handle_or_title[6..-1]
      dsos = DSpace.findByMetadataValue('dc.title', str, DConstants::ITEM)
      if (dsos.length > 1) then
        raise "multiple matches for #{type_id_or_handle_or_title}"
      end
      return dsos[0]
    else
      splits = type_id_or_handle_or_title.split('.', 2)
      if (2 == splits.length) then
        self.find(splits[0].upcase, splits[1])
      else
        java_import org.dspace.handle.HandleManager
        return HandleManager.resolve_to_object(DSpace.context, type_id_or_handle_or_title);
      end
    end
  end

  # Access the service manager for the DSpace kernel
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-services/src/main/java/org/dspace/servicemanager/DSpaceServiceManager.java
  # @return [org.dspace.servicemanager.DSpaceServiceManager]
  def self.getServiceManager
    org.dspace.utils.DSpace.new().getServiceManager()
  end

  # Access a service object registered with the DSpace kernel
  # This follows the enterprise design pattern: https://en.wikipedia.org/wiki/Service_locator_pattern
  # This is primarily used for interfacing indirectly with external services integrated with DSpace (e. g. Apache Solr for discovery)
  # @see 
  def self.getService(service_name, java_klass)
    getServiceManager().getServiceByName(service_name,java_klass)
  end

  # Access the SolrServiceImpl object
  # This is primarily used for interfacing directly with the underlying Apache Solr installation
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/discovery/SolrServiceImpl.java
  # @return [org.dspace.discovery.SolrServiceImpl]
  def self.getIndexService()
    java_import org.dspace.discovery.SolrServiceImpl;
    self.getService("org.dspace.discovery.IndexingService", SolrServiceImpl)
  end

  # Queries the DSpace database for DSpace Communities, Collections, and Items which fall within a user-defined resource policy
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/DSpaceObject.java
  # @see [org.dspace.content.DSpaceObject]
  # @param fully_qualified_metadata_field [String] the metadata field used for the query (e.g. dc.title or dc.date.accessioned)
  # @param value_or_nil [String] the value for the metadata field in the query
  # @param restrict_to_type [String] the type of resource
  # @return [org.dspace.content.DSpaceObject] the DSpace Objects
  #
  # @note restrict_to_type must be one of BITSTREAM or EPERSON
  # @note if value_or_nil is nil and restrict_to_type is nil, this will return all DSpaceObjects with the value for the given metadata field
  # @note if value_or_nil is not nil, this will restrict to those DSpace Objects which have metadata field values requal to the value
  # @note if restrict_to_typ is not nil, this will restrict to results to the provided resource type
  def self.findByMetadataValue(fully_qualified_metadata_field, value_or_nil, restrict_to_type)
    java_import org.dspace.storage.rdbms.DatabaseManager
    field = DMetadataField.find(fully_qualified_metadata_field)
    raise "no such metadata field #{fully_qualified_metadata_field}" if field.nil?

    sql = "SELECT MV.resource_id, MV.resource_type_id  FROM MetadataValue MV";
    sql = sql + " where MV.metadata_field_id= #{field.getFieldID} "
    if (restrict_to_type) then
      sql = sql + " AND MV.resource_type_id = #{objTypeId(restrict_to_type)}"
    end
    if (not value_or_nil.nil?) then
      sql = sql + " AND MV.text_value LIKE ?"
      tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue", sql, value_or_nil)
    else
      tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue", sql)
    end


    dsos = [];
    while (iter = tri.next())
      dsos << self.find(iter.getIntColumn("resource_type_id"), iter.getIntColumn("resource_id"))
    end
    tri.close
    return dsos
  end

  # Queries the DSpace database for DSpace Communities, Collections, and Items which fall within a user-defined resource policy
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/DSpaceObject.java
  # @return [org.dspace.content.DSpaceObject]
  def self.findByGroupPolicy(group_ref_or_name, action_or_nil, resource_type_or_nil)
    java_import org.dspace.eperson.Group
    java_import org.dspace.storage.rdbms.DatabaseManager

    group = DGroup.find(group_ref_or_name) if group_ref_or_name.is_a? String
    raise "must give valied group" if group == nil or not group.is_a? Java::OrgDspaceEperson::Group

    sql = "SELECT RESOURCE_ID, RESOURCE_TYPE_ID FROM RESOURCEPOLICY WHERE EPERSONGROUP_ID = #{group.getID} ";
    sql += "AND ACTION_ID = #{action_or_nil} " if action_or_nil
    sql += "AND RESOURCE_TYPE_ID = #{resource_type_or_nil} " if resource_type_or_nil

    tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue", sql)
    dsos = [];
    while (iter = tri.next())
      dsos << self.find(iter.getIntColumn("resource_type_id"), iter.getIntColumn("resource_id"))
    end
    tri.close
    return dsos
  end

  # Provides documentation using STDOUT for the methods on the DSpace Classes
  # print available static methods for the give classes
  def self.help(klasses = [DCommunity, DCollection, DItem, DBundle, DBitstream, DEPerson,
                           DWorkflowItem, DWorkspaceItem, DMetadataField, DConstants, DSpace])
    klasses.each do |klass|
      klass.singleton_methods.sort.each do |mn|
        m = klass.method(mn)
        plist = m.parameters.collect { |p|
          if (p[0] == :req) then
            "#{p[1].to_s}"
          else
            "[ #{p[1].to_s} ]"
          end
        }
        puts "#{klass.name}.#{mn.to_s} (#{plist.join(", ")})"
      end
    end
    return nil
  end

  # This models the configuration used by the DSpace kernel
  class Config

    # constructor
    # @param dspace_home [String] the path to the DSpace installation directory
    def initialize(dspace_home)
      @dspace_dir = dspace_home
      puts "Using #{@dspace_dir}"
      @dspace_cfg = "#{@dspace_dir}/config/dspace.cfg";
      @dspace_jars ||= Dir[File.join(@dspace_dir, 'lib/*.jar')]
      @context = nil;
      @kernel = nil;
    end

    # Accessor for the DSpace installation directory
    # @return [String]
    def dspace_dir
      @dspace_dir || raise('dspace_dir is undefined');
    end

    # Accessor for the DSpace installation configuration file
    # @return [String]
    def dspace_cfg
      @dspace_cfg || raise('dspace.cfg is undefined');
    end

    # Accessor for the DSpace kernel context object
    # @return [org.dspace.core.Context]
    def context
      init
      return @context
    end

    # This rebuilds the Context object for the DSpace kernel
    # @return [org.dspace.core.Context]
    def context_renew
      @context.abort if @context
      @context = org.dspace.core.Context.new()
    end

    # Builds the org.dspace.core.Context Class
    # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/core/Context.java
    # @return [org.dspace.core.Context]
    def init
      if @context.nil? then
        puts "Loading jars"
        @dspace_jars.each do |jar|
          require jar
        end
        puts "Loading #{@dspace_cfg}"
        org.dspace.core.ConfigurationManager.load_config(@dspace_cfg)

        kernel_impl = org.dspace.servicemanager.DSpaceKernelInit.get_kernel(nil)
        if not kernel_impl.is_running then
          puts "Starting new DSpaceKernel"
          kernel_impl.start(@dspace_dir)
        end
        @kernel = kernel_impl;

        @context = org.dspace.core.Context.new()
      end
    end

    # Print to STDOUT the current database connection information
    def print
      puts "DB #{@context.getDBConnection.toString}"
    end
  end
end
