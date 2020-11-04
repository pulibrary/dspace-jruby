# frozen_string_literal: true

# Module providing interfaces for interfacing with the DSpace kernel
module DSpace
  autoload(:Deprecation, File.join(File.dirname(__FILE__), 'dspace', 'deprecation'))
  extend(Deprecation)

  autoload(:Config, File.join(File.dirname(__FILE__), 'dspace', 'config'))
  autoload(:Core, File.join(File.dirname(__FILE__), 'dspace', 'core'))

  DEFAULT_DSPACE_HOME = '/dspace'

  @@root_path = nil
  @@config = nil

  def self.dspace_home
    ENV['DSPACE_HOME'] || DEFAULT_DSPACE_HOME
  end

  def self.require_dspace_libraries
    Dir[File.join(dspace_home, 'lib', '**', '*.jar')].each { |jar_path| require(jar_path) }
  end

  # This is needed in order to invoke any of these methods
  require_dspace_libraries

  def self.kernel_constants_class
    org.dspace.core.Constants
  end

  # Retrieve the Class modeling the internal DSpace Object using a string or integer constant for the resource ID
  # @param type_str_or_int [String]
  # @return [Object]
  #
  # @note type_str_or_int must be one of the following constant values: BITTREAM or EPERSON, or the corresponding string for these constants
  def self.objTypeStr(type_str_or_int)
    if type_str_or_int.instance_of?(String) && kernel_constants_class.typeText.find_index(type_str_or_int.upcase)
      type_str_or_int.capitalize
    else
      begin
        id = Integer(type_str_or_int)
      rescue StandardError
        raise "no such object type #{type_str_or_int}"
      end

      Core::Constants.typeStr(id)
    end
  end

  # Convert a String to an internal DSpace constant for resolving resource type
  # @param type_str_or_int [String]
  # @return [Integer]
  def self.objTypeId(type_str_or_int)
    constant_value = objTypeStr(type_str_or_int).upcase
    kernel_constants_class.typeText.find_index(constant_value)
  end

  def self.build_config(root_path:)
    Config.new(root_path)
  end

  # Initialize the DSpace kernel by searching within directory for the DSpace installation
  # @param dspace_dir [String]
  # @note if dspace_dir is nil, this will use the value of the environment variable $DSPACE_HOME
  # @note if $DSPACE_HOME is undefined also, it will then default to '/dspace'
  def self.bootstrap(dspace_root_path: nil)
    @@root_path = dspace_root_path || dspace_home if @@root_path.nil? || dspace_root_path != @@root_path

    @@config = build_config(root_path: @@root_path) if @@config.nil?

    @@config.init
    @@config&.print
    @@config
  end

  def self.load(dspace_root_path: nil)
    # I do not understand why this is failing on certain environments
    # warn_deprecated('load', 'bootstrap')

    bootstrap(dspace_root_path: dspace_root_path)
  end

  # Reinitialize the DSpace kernel by searching within directory for the DSpace installation
  # @param dspace_dir [String]
  # @note if dspace_dir is nil, this will use the value of the environment variable $DSPACE_HOME
  # @note if $DSPACE_HOME is undefined also, it will then default to '/dspace'
  def self.reload(dspace_root_path: nil)
    @@config = nil
    bootstrap(dspace_root_path: dspace_root_path)
  end

  # Accesses the global context for interfacing with the DSpace kernel
  # @raise [StandardError]
  # @return [org.dspace.core.Context]
  def self.context
    bootstrap if @@config.nil?
    @@config.context
  end

  # Resets the current context used for interfacing with the DSpace kernel
  # @note this *will* ensure that all changes which have not been committed to the database will be lost
  # @raise [StandardError]
  # @return [org.dspace.core.Context]
  def self.context_renew
    bootstrap if @@config.nil?

    @@config.context_renew
  end

  # Sets the current user for this session of working with the DSpace kernel. Raise
  #   error if person does not exist.
  # @note this is necessary in order to provide admin. access for modifying DSpace Objects
  # @param [String] netid the institutional NetID used to find the user account for the login
  def self.login(netid)
    person = Core::EPerson.find(netid)
    raise Core::EPerson::NotFoundError(EPerson("#{netid} could not be found")) if person.nil?

    context.setCurrentUser(person)
    context
  end

  def self.current_user
    context.getCurrentUser
  end

  # Commit changes to the database for the current DSpace installation
  # @see Context.commit
  def self.commit
    context.commit
  end

  # Construct one of the wrapper Objects from one of the internal DSpace Objects
  # @raise [StandardError]
  # @return [org.dspace.content.DSpaceObject]
  def self.create(dso)
    raise 'DSpace API object must not be nil' if dso.nil?

    last_segment = dso.class.name.split('::').last
    klass_name = "DSpace::Core::#{last_segment}"
    klass = klass_name.constantize
    klass.new(dso)
  end

  # Construct and inspect a DSpace Object
  # @param dso [org.dspace.content.DSpaceObject]
  # @return [String]
  # @see org.dspace.content.DSpaceObject#inspect
  def self.inspect(dso)
    dso = create(dso) if dso
    dso.inspect
  end

  # Method for retrieving a DSpace object by the resource type and internal ID
  # @param type_str_or_int [String]
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
    type_str = objTypeStr(type_str_or_int)
    type_id = objTypeId(type_str)

    klass_name = "DSpace::Core::#{type_str}"
    klass = Object.const_get(klass_name)

    begin
      id = Integer(identifier)
    rescue StandardError
      id = identifier
    end

    klass.find(id)
  end

  # Method for retrieving a DSpace object by the internal ID, Handle, or title
  # @param type_id_or_handle_or_title [String]
  # @return [org.dspace.content.DSpaceObject]
  def self.fromString(type_id_or_handle_or_title)
    # TODO: handle MetadataField string
    if type_id_or_handle_or_title.start_with? 'TITLE'
      str = type_id_or_handle_or_title[6..-1]
      dsos = findByMetadataValue('dc.title', str, DConstants::ITEM)
      raise "multiple matches for #{type_id_or_handle_or_title}" if dsos.length > 1

      dsos[0]
    else
      splits = type_id_or_handle_or_title.split('.', 2)
      if splits.length == 2
        find(splits[0].upcase, splits[1])
      else
        java_import org.dspace.handle.HandleManager
        HandleManager.resolve_to_object(context, type_id_or_handle_or_title)
      end
    end
  end

  # Access the service manager for the DSpace kernel
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-services/src/main/java/org/dspace/servicemanager/DSpaceServiceManager.java
  # @return [org.dspace.servicemanager.DSpaceServiceManager]
  def self.getServiceManager
    utils_helper = org.dspace.utils.DSpace.new
    utils_helper.getServiceManager
  end

  # Access a service object registered with the DSpace kernel
  # This follows the enterprise design pattern: https://en.wikipedia.org/wiki/Service_locator_pattern
  # This is primarily used for interfacing indirectly with external services integrated with DSpace (e. g. Apache Solr for discovery)
  # @see
  def self.getService(service_name, java_klass)
    getServiceManager.getServiceByName(service_name, java_klass)
  end

  # Access the SolrServiceImpl object
  # This is primarily used for interfacing directly with the underlying Apache Solr installation
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/discovery/SolrServiceImpl.java
  # @return [org.dspace.discovery.SolrServiceImpl]
  def self.getIndexService
    java_import org.dspace.discovery.SolrServiceImpl
    getService('org.dspace.discovery.IndexingService', SolrServiceImpl)
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
    field = Core::MetadataField.find(fully_qualified_metadata_field)
    raise "no such metadata field #{fully_qualified_metadata_field}" if field.nil?

    sql = 'SELECT MV.resource_id, MV.resource_type_id  FROM MetadataValue MV'
    sql += " where MV.metadata_field_id= #{field.getFieldID} "
    sql += " AND MV.resource_type_id = #{objTypeId(restrict_to_type)}" if restrict_to_type
    if !value_or_nil.nil?
      sql += ' AND MV.text_value LIKE ?'
      tri = DatabaseManager.queryTable(context, 'MetadataValue', sql, value_or_nil)
    else
      tri = DatabaseManager.queryTable(context, 'MetadataValue', sql)
    end

    dsos = []
    while (iter = tri.next)
      dsos << find(iter.getIntColumn('resource_type_id'), iter.getIntColumn('resource_id'))
    end
    tri.close
    dsos
  end

  # Queries the DSpace database for DSpace Communities, Collections, and Items which fall within a user-defined resource policy
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/DSpaceObject.java
  # @return [org.dspace.content.DSpaceObject]
  def self.findByGroupPolicy(group_ref_or_name, action_or_nil, resource_type_or_nil)
    java_import org.dspace.eperson.Group
    java_import org.dspace.storage.rdbms.DatabaseManager

    group = Core::Group.find(group_ref_or_name) if group_ref_or_name.is_a? String
    raise 'must give valied group' if group.nil? || (!group.is_a? Java::OrgDspaceEperson::Group)

    sql = "SELECT RESOURCE_ID, RESOURCE_TYPE_ID FROM RESOURCEPOLICY WHERE EPERSONGROUP_ID = #{group.getID} "
    sql += "AND ACTION_ID = #{action_or_nil} " if action_or_nil
    sql += "AND RESOURCE_TYPE_ID = #{resource_type_or_nil} " if resource_type_or_nil

    tri = DatabaseManager.queryTable(context, 'MetadataValue', sql)
    dsos = []
    while (iter = tri.next)
      dsos << find(iter.getIntColumn('resource_type_id'), iter.getIntColumn('resource_id'))
    end
    tri.close
    dsos
  end

  def self.klasses
    [
      Community,
      Collection,
      Item,
      Bundle,
      Bitstream,
      EPerson,
      WorkflowItem,
      WorkspaceItem,
      MetadataField,
      Constants
    ]
  end

  # Provides documentation using STDOUT for the methods on the DSpace Classes
  # print available static methods for the give classes
  def self.help
    klasses.each do |klass|
      klass.singleton_methods.sort.each do |mn|
        m = klass.method(mn)
        plist = m.parameters.collect do |p|
          if p[0] == :req
            (p[1]).to_s
          else
            "[ #{p[1]} ]"
          end
        end
        puts "#{klass.name}.#{mn} (#{plist.join(', ')})"
      end
    end
  end
end
