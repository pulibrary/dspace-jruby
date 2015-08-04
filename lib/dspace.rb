require 'dspace/dso'
require 'dspace/deperson'
require 'dspace/dgroup'
require 'dspace/dcollection'
require 'dspace/dcommunity'

DSO.initialize

module DSpace
  VERSION = "0.0.2"

  ROOT = File.expand_path('../..', __FILE__)
  @@config = nil;

  def self.load(dspace_dir = nil)
    if (@@config.nil?) then
      @@config =  Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
      self.context  # initialize context now
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

  class Config
    def initialize(dspace_home)
      @dspace_dir = dspace_home
      puts "Using #{@dspace_dir}"
      @dspace_cfg = "#{@dspace_dir}/config/dspace.cfg";
      @dspace_jars ||= Dir[File.join(@dspace_dir, 'lib/*.jar')]
      @context = nil;
    end

    def dspace_dir
      @dspace_dir || raise('dspace_dir is undefined');
    end

    def dspace_cfg
      @dspace_cfg || raise('dspace.cfg is undefined');
    end

    def context
      return @context if @context

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

      @context = org.dspace.core.Context.new()
      return @context
    end

  end

end

