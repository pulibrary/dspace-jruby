
module Dscriptor
  class Config
    def initialize(dspace_home)
      @dspace_dir = dspace_home
      puts "Using #{@dspace_dir}"
      @dspace_cfg = "#{@dspace_dir}/config/dspace.cfg";
      @dspace_jars ||= Dir[File.join(@dspace_dir, 'lib/*.jar')]
    end

    def dspace_dir
      @dspace_dir ||= File.expand_path('../..', @dspace_cfg)
    end

    def dspace_cfg
      @dspace_cfg || raise('No dspace.cfg');
    end
  end
end
