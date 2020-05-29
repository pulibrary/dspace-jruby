# require_relative '../../spec_helper'

# The dspace/dspace.rb contains quite a few technical errors that require serious
#   debugging. See dspace_spec.rb for details.

describe DSpace::Config do

  describe '.new' do

    # before do
    #   allow(File).to receive(:join).and_return(["lib/foo.jar"], ["lib/bar.jar"])
    # end

    it 'constructs a new Config object using the path to the DSpace installation' do
      dspace_dir_path = '/dspace'
      new_config = DSpace::Config.new(dspace_dir_path)

      expect(new_config).not_to be_nil
      expect(new_config.dspace_dir).to eq(dspace_dir_path)
      expect(new_config.dspace_cfg).to eq("#{dspace_dir_path}/config/dspace.cfg")
    end

    # NOTE: This may be the ideal configuration, but currently it does not follow
    #   this behavior. Calling DSpace::Config directly with bad dir paths will
    #   not raise an error.
    # context "when the directory for the DSpace installation does not exist" do
    #   before do
    #     allow(File).to receive(:join).and_call_original
    #   end

    #   it 'raises an error' do
    #     bad_dspace_dir_path = '/foo/bar'
    #     new_config = DSpace::Config.new(bad_dspace_dir_path)

    #     expect { new_config }.to raise_error(StandardError)
    #   end
    # end
  end

  describe '#dspace_dir' do
  # Accessor for the DSpace installation directory
  # @return [String]
  end

  describe '#dspace_cfg' do
  # Accessor for the DSpace installation configuration file
  # @return [String]
  #
  end

  describe '#context' do
  # Accessor for the DSpace kernel context object
  # @return [org.dspace.core.Context]
  # TODO: Either find the reasoning behind including init in this accessor
  #   or separate out functionality
  end

  describe '#context_renew' do
  # This rebuilds the Context object for the DSpace kernel
  # @return [org.dspace.core.Context]
  end

  describe '#init' do
  # Builds the org.dspace.core.Context Class
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/core/Context.java
  # @return [org.dspace.core.Context]
  end

  describe '#print' do
  # Print to STDOUT the current database connection information
  end



end
