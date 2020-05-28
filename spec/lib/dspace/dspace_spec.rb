require_relative '../../spec_helper'

describe DSpace do

  describe '.load' do
    before do 
      # TODO: Reset DSpace before each load
      #   DSpace.context.abort is a good start, but variables need to be reset as well
    end

    after :all do
      # TODO: Make sure DSpace is loaded properly for all tests
    end

=begin
The gem requires that DSpace.load work the first time. If an improper path is 
fed into .load, the user will need to restart the entire environment. Not all 
configurations and variables are reset when using .load more than once, and
.reload does not seem to work at all. Significant debugging is required to 
achieve the desired functionality.
=end

    it 'loads the DSpace kernel for the API' do
      dspace_dir_path = '/dspace'
      # expect { DSpace.load(dspace_dir_path) }.not_to raise_error
    end

    it 'throw error when given bad path' do
      bad_dspace_dir_path = '/foo/bar'
      # expect { DSpace.load(bad_dspace_dir_path) }.to raise_error
    end
  end

  describe '.reload' do
    # See notes under .load
  end

end
