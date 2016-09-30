module DSpace
  ROOT = File.expand_path('../..', __FILE__)
  @@config = nil;


  ##
  # return the name of the wrapper klass that corresponds to the give parameter
  #
  # type_str_or_int must be oe of the integer values: BITTREAM .. EPERSON, or the corresponding string
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

  ##
  # convert string to corresponding constant: BITSTREAM, BUNDLE, ...
  def self.objTypeId(type_str_or_int)
    obj_typ = Constants.typeText.find_index objTypeStr(type_str_or_int).upcase
  end

  ##
  # load DSpace configurations and jar files from the dspace_dir directory;
  # if dspace_dir is nil use the value of the environment variable 'DSPACE_HOME' or if undefined as well default to '/dspace'
  def self.load(dspace_dir = nil)
    if (@@config.nil?) then
      @@config = Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
      self.context # initialize context now
      java_import org.dspace.handle.HandleManager;
      java_import org.dspace.core.Constants
      java_import org.dspace.content.DSpaceObject
    end
    puts "DB #{DSpace.context.getDBConnection.toString}"
    return @@config != nil
  end

  ##
  # return the current org.dspace.core.Context
  #
  # this method fails unless it is preceded by a successfull DSPace.load call
  def self.context
    raise "must call load to initialize" if @@config.nil?
    raise "should never happen" if @@config.context.nil?
    return @@config.context
  end

  ##
  # renew  the current org.dspace.core.Context; this abandons any uncommited database changes
  def self.context_renew
    raise "must call load to initialize" if @@config.nil?
    raise "should never happen" if @@config.context.nil?
    return @@config.context_renew
  end

  ##
  # set the current dspace user to the one with the given netid
  def self.login(netid)
    self.context.setCurrentUser(DEPerson.find(netid))
    return nil
  end

  ##
  # commit changes to the database
  def self.commit
    self.context.commit
  end

  ##
  # commit a wrapper object for the given java object;
  # the type of the warpper is determined by the class of the given java object
  #
  def self.create(dso)
    raise "dso must not be nil" if dso.nil?
    klass = Object.const_get "D" + dso.class.name.gsub(/.*::/, '')
    klass.send :new, dso
  end

  ##
  #  return DSPace.create(dso).inspect or "nil"
  def self.inspect(dso)
    dso = DSpace.create(dso) if dso
    dso.inspect
  end
  ##
  # return the DSpace object that is identified by the given type and identifier
  #
  # type_str_or_int must be oe of the integer values: BITTREAM .. EPERSON, or the corresponding string
  #
  # identifier must be an integer or string value uniquely identifying the object
  #
  #     DSpace.find(DSpace::COLLECTION, 106)
  #     DSpace.find("ITEM", 10)
  #     DSpace.find("GROUP", "Anonymous")
  #     DSpace.find("EPERSON", "her@there.com")
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

  def self.fromString(type_id_or_handle)
    #TODO handle MetadataField string
    splits = type_id_or_handle.split('.', 2)
    if (2 == splits.length) then
      self.find(splits[0].upcase, splits[1])
    else
      java_import org.dspace.handle.HandleManager
      return HandleManager.resolve_to_object(DSpace.context, type_id_or_handle);
    end
  end

  ##
  # get dpace service manager
  def self.getServiceManager
    org.dspace.utils.DSpace.new().getServiceManager()
  end

  ##
  # get a dspace service by name
  def self.getService(service_name, java_klass)
    getServiceManager().getServiceByName(service_name,java_klass)
  end

  ##
  # get the SoltServiveImpl
  def self.getIndexService()
    java_import org.dspace.discovery.SolrServiceImpl;
    self.getService("org.dspace.discovery.IndexingService", SolrServiceImpl)
  end

  ##
  # if value_or_nil is nil and restrict_to_type is nil return all DSpaceObjects have a value for the
  # given metadata field
  #
  # if value_or_nil is not nil restrict to those whose value is equal to the given paramter
  #
  # if restrict_to_typ is not nil, restrict to results of the given type
  #
  # restrict_to_type must be one of BITSTREAM, .., EPERSON

  def self.findByMetadataValue(fully_qualified_metadata_field, value_or_nil, restrict_to_type)
    java_import org.dspace.storage.rdbms.DatabaseManager
    field = DMetadataField.find(fully_qualified_metadata_field)
    raise "no such metadata field #{fully_qualified_metadata_field}" if field.nil?

    sql = "SELECT MV.resource_id, MV.resource_type_id  FROM MetadataValue MV";
    sql = sql + " where MV.metadata_field_id= #{field.getFieldID} "
    if (not value_or_nil.nil?) then
      sql = sql + " AND MV.text_value LIKE '#{value_or_nil}'"
    end
    if (restrict_to_type) then
      sql = sql + " AND MV.resource_type_id = #{objTypeId(restrict_to_type)}"
    end

    tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue", sql)
    dsos = [];
    while (iter = tri.next())
      dsos << self.find(iter.getIntColumn("resource_type_id"), iter.getIntColumn("resource_id"))
    end
    tri.close
    return dsos
  end

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
  ##
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

  class Config
    def initialize(dspace_home)
      @dspace_dir = dspace_home
      puts "Using #{@dspace_dir}"
      @dspace_cfg = "#{@dspace_dir}/config/dspace.cfg";
      @dspace_jars ||= Dir[File.join(@dspace_dir, 'lib/*.jar')]
      @context = nil;
      @kernel = nil;
    end

    def dspace_dir
      @dspace_dir || raise('dspace_dir is undefined');
    end

    def dspace_cfg
      @dspace_cfg || raise('dspace.cfg is undefined');
    end

    def context
      init
      return @context
    end

    def context_renew
      @context.abort if @context
      @context = org.dspace.core.Context.new()
    end

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
  end

end

