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

  def self.load(dspace_dir = nil)
    if (@@config.nil?) then
      @@config = Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
      self.context # initialize context now
      java_import org.dspace.content.DSpaceObject
      java_import org.dspace.handle.HandleManager;
      java_import org.dspace.core.Constants
      return true
    end
    return false
  end

  def self.context
    raise "must call load to initialize" if @@config.nil?
    raise "should never happen" if @@config.context.nil?
    return @@config.context
  end

  def self.login(netid)
    self.context.setCurrentUser(DEperson.find(netid))
    return nil
  end

  def self.commit
    self.context.commit
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

  def self.fromObj(dobj)
    klass = Object.const_get "D" + dobj.getType.capitaize
    klass.send :new, dobj
  end

  def self.find(type_str, identifier)
    klass = Object.const_get "D" + type_str.capitalize
    int_id = identifier.to_i
    if (identifier == int_id) then
      type = self.const_get type_str.upcase
      klass.send :new, DSpaceObject.find(DSpace.context, type, int_id)
    elsif klass.methods.include? :find
      klass.send :find, identifier
    end
  end

  def self.create(dso)
    raise "dso must not be nil" if dso.nil?
    klass =  Object.const_get  "D" + dso.class.name.gsub(/.*::/,'')
    klass.send :new, dso
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

