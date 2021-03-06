# frozen_string_literal: true

module DSpace
  # This models the configuration used by the DSpace kernel
  class Config
    java_import(org.dspace.content.DSpaceObject)
    java_import(org.dspace.core.Constants)
    java_import(org.dspace.handle.HandleManager)

    # constructor
    # @param dspace_home [String] the path to the DSpace installation directory
    def initialize(dspace_home)
      @dspace_dir = dspace_home
      puts "Using #{@dspace_dir}"
      @dspace_cfg = "#{@dspace_dir}/config/dspace.cfg"
      @dspace_jars ||= Dir[File.join(@dspace_dir, 'lib/*.jar')]
      @context = nil
      @kernel = nil
    end

    # rubocop:disable Naming/MemoizedInstanceVariableName
    def load_jar_files
      @loaded_jar_files ||= @dspace_jars.map { |jar_file| require(jar_file) }
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName

    # Accessor for the DSpace installation directory
    # @return [String]
    def dspace_dir
      @dspace_dir || raise('dspace_dir is undefined')
    end

    # Accessor for the DSpace installation configuration file
    # @return [String]
    def dspace_cfg
      @dspace_cfg || raise('dspace.cfg is undefined')
    end

    # Accessor for the DSpace kernel context object
    # @return [org.dspace.core.Context]
    def context
      init
      @context
    end

    # This rebuilds the Context object for the DSpace kernel
    # @return [org.dspace.core.Context]
    def context_renew
      @context&.abort
      @context = org.dspace.core.Context.new
    end

    # Builds the org.dspace.core.Context Class
    # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/core/Context.java
    # @return [org.dspace.core.Context]
    def init
      return @context unless @context.nil?

      puts 'Loading jars'

      load_jar_files

      puts "Loading #{@dspace_cfg}"
      org.dspace.core.ConfigurationManager.load_config(@dspace_cfg)

      kernel_impl = org.dspace.servicemanager.DSpaceKernelInit.get_kernel(nil)
      unless kernel_impl.is_running
        puts 'Starting new DSpaceKernel'
        kernel_impl.start(@dspace_dir)
      end
      @kernel = kernel_impl

      @context = org.dspace.core.Context.new
    end

    # Print to STDOUT the current database connection information
    def print
      puts "DB #{@context.getDBConnection.toString}"
    end
  end
end
