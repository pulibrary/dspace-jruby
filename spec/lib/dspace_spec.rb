require_relative '../spec_helper'

describe DSpace do

  describe '.load' do

    let(:"org.dspace.core.ConfigurationManager") { Class.new }
    before do
      # stub_const("org.dspace.core.ConfigurationManager", fake_class)

    end

    it 'loads the DSpace kernel for the API' do
      debugger
      dspace_dir_path = '/foo/bar'
      expect { DSpace.load(dspace_dir_path) }.not_to raise_error(StandardError)
    end
  end
end
