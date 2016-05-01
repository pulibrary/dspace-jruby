module DSpace
  ROOT = File.expand_path('../..', __FILE__)
  @@config = nil;

  BITSTREAM = 0;
  BUNDLE = 1;
  ITEM = 2;
  COLLECTION = 3;
  COMMUNITY = 4;
  SITE = 5;
  GROUP = 6;
  EPERSON = 7;

  def self.objTypeId(type_str_or_int)
    obj_typ = Constants.typeText.find_index type_str_or_int
    if  obj_typ.nil? then
      obj_typ = Integer(type_str_or_int)
      raise "no such object typ #{type_str_or_int}" unless Constants.typeText[obj_typ]
    end
    return obj_typ;
  end

  def self.objTypeStr(type_str_or_int)
    return type_str_or_int  if Constants.typeText.find_index type_str_or_int
    obj_typ_id = Integer(type_str_or_int)
    raise "no such object type #{type_str_or_int}" unless Constants.typeText[obj_typ_id]
    return Constants.typeText[obj_typ_id];
  end

  def self.load(dspace_dir = nil)
    if (@@config.nil?) then
      @@config = Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
      self.context # initialize context now
      java_import org.dspace.handle.HandleManager;
      java_import org.dspace.core.Constants
      java_import org.dspace.content.DSpaceObject
      return true
    else
      puts "Already loaded #{@@config.dspace_cfg}"
    end
    return false
  end

  def self.context
    raise "must call load to initialize" if @@config.nil?
    raise "should never happen" if @@config.context.nil?
    return @@config.context
  end

  def self.login(netid)
    self.context.setCurrentUser(DEPerson.find(netid))
    return nil
  end

  def self.commit
    self.context.commit
  end

  def self.create(dso)
    raise "dso must not be nil" if dso.nil?
    klass =  Object.const_get  "D" + dso.class.name.gsub(/.*::/,'')
    klass.send :new, dso
  end

  def self.fromString(type_id_or_handle)
    splits = type_id_or_handle.split('.')
    if (2 == splits.length) then
      self.find(splits[0], splits[1])
    else
      self.fromHandle(type_id_or_handle)
    end
  end

  def self.fromHandle(handle)
    return HandleManager.resolve_to_object(DSpace.context, handle);
  end

  def self.find(type_str_or_int, identifier)
    type_str = DSpace.objTypeStr(type_str_or_int)
    type_id = DSpace.objTypeId(type_str)
    int_id = identifier.to_i
    obj = DSpaceObject.find(DSpace.context, type_id, int_id)
    return obj
  end

  def self.findByMetadataValue(fully_qualified_metadata_field, value_or_nil, restrict_to_type)
      java_import org.dspace.content.MetadataSchema
      java_import org.dspace.content.MetadataField
      java_import org.dspace.storage.rdbms.DatabaseManager
      java_import org.dspace.storage.rdbms.TableRow

      (schema, element, qualifier) = fully_qualified_metadata_field.split('.')
      schm = MetadataSchema.find(DSpace.context, schema)
      raise "no such metadata schema: #{schema}" if schm.nil?
      field = MetadataField.find_by_element(DSpace.context, schm.getSchemaID, element, qualifier)
      raise "no such metadata field #{fully_qualified_metadata_field}" if field.nil?

      sql = "SELECT MV.resource_id, MV.resource_type_id  FROM MetadataValue MV";
      sql = sql + " where MV.metadata_field_id= #{field.getFieldID} "
      if (not value_or_nil.nil?) then
        sql = sql + " AND MV.text_value LIKE '#{value_or_nil}'"
      end
      if (restrict_to_type) then
        sql = sql + " AND MV.resource_type_id = #{objTypeId(restrict_to_type)}"
      end

      tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue",   sql)
      dsos = [];
      while (iter = tri.next())
        dsos << self.find(iter.getIntColumn("resource_type_id"), iter.getIntColumn("resource_id") )
      end
      tri.close
      return dsos
    end


  def self.kernel
    @@config.kernel;
  end

  def self.help( klasses = [ DSpace, DCommunity, DCollection, DItem, DGroup])
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
      raise "must call load to initialize" if @@config.nil?
      raise "should never happen" if @@config.context.nil?
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


  def self.to_string(java_obj)
     return "nil" unless java_obj
     klass = java_obj.getClass.getName
     if (klass == "org.dspace.content.MetadataField") then
       java_import org.dspace.content.MetadataField
       java_import org.dspace.content.MetadataSchema

       schema = MetadataSchema.find(DSpace.context, java_obj.schemaID)
       str = "#{schema.getName}.#{java_obj.element}"
       str += ".#{java_obj.qualifier}" if java_obj.qualifier
       str
     else
       java_obj.toString
     end
  end
end

