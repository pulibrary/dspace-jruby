require 'dscriptor/version'
require 'dscriptor/config'
require 'dscriptor/mixins'

module Dscriptor

  ROOT = File.expand_path('../..', __FILE__)
  @@context = nil;

  def self.prepare(dspace_dir = nil)
    dspector = Config.new(dspace_dir || ENV['DSPACE_HOME'] || "/dspace")
    #puts "Loading from jars from #{dspector.dspace_dir}/lib/*.jar"
    Dir[File.join(dspector.dspace_dir, 'lib/*.jar')].each do |jar|
      #puts "require #{jar}"
      require jar
    end

    #puts "ConfigurationManager.load_config #{dspector.dspace_cfg}"
    org.dspace.core.ConfigurationManager.load_config(dspector.dspace_cfg)

    kernel_impl = org.dspace.servicemanager.DSpaceKernelInit.get_kernel(nil)
    if not kernel_impl.is_running then
      puts "Starting new DSpaceKernel"
      kernel_impl.start(@dspace_dir)
    end
    return dspector
  end

  def self.context
    @@context = @@context || org.dspace.core.Context.new()
    return @@context
  end
end
