module DSpace
  ROOT = File.expand_path('../..', __FILE__)
  @@config = nil;

  def self.load(dspace_dir = nil)
    if (@@config.nil?) then
      @@config = Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
      self.context # initialize context now
      return true
    end
    return false
  end

  def self.context
    raise "must call load to initialize" if @@config.nil?
    raise "that should not happen" if @@config.context.nil?
    return @@config.context
  end

  def self.login(netid)
    self.context.setCurrentUser(DEPerson.find(netid))
    return nil
  end

  def self.commit
    self.context.commit
  end


  BITSTREAM = 0;
  BUNDLE = 1;
  ITEM = 2;
  COLLECTION = 3;
  COMMUNITY = 4;
  SITE = 5;
  GROUP = 6;
  EPERSON = 7;

  def self.fromHandle(handle)
    java_import org.dspace.content.DSpaceObject
    java_import org.dspace.handle.HandleManager;
    return HandleManager.resolve_to_object(DSpace.context, handle);
  end

  def self.fromString(type_id_or_handle)
    java_import org.dspace.content.DSpaceObject
    DSpaceObject.fromString(DSpace.context, type_id_or_handle)
  end

  def self.find(type, id)
    java_import org.dspace.core.Constants
    self.fromString("#{Constants.typeText[type]}.#{id}")
  end

  def self.items(restrict_to_dso)
    java_import org.dspace.storage.rdbms.DatabaseManager
    java_import org.dspace.storage.rdbms.TableRow

    return [] if restrict_to_dso.nil?
    return [restrict_to_dso] if restrict_to_dso.getType == ITEM
    return [] if restrict_to_dso.getType != COLLECTION and restrict_to_dso.getType != COMMUNITY

    sql = "SELECT ITEM_ID FROM ";
    if (restrict_to_dso.getType() == COLLECTION) then
      sql = sql + "  Collection2Item CO WHERE  CO.Collection_Id = #{restrict_to_dso.getID}"
    else
      # must be COMMUNITY
      sql = sql + " Community2Item CO  WHERE CO.Community_Id = #{restrict_to_dso.getID}"
    end
    # puts sql;

    tri = DatabaseManager.queryTable(DSpace.context, "MetadataValue",   sql)
    dsos = [];
    while (i = tri.next())
      item =  self.find(DSO::ITEM, i.getIntColumn("item_id"))
      dsos << item
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

    def kernel
      init
      return @kernel
    end

    def context
      init
      return @context
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

