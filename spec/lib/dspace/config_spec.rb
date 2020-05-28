require_relative '../../spec_helper'

describe DSpace::Config do

  describe '.new' do

    before do
      allow(File).to receive(:join).and_return(["lib/foo.jar"], ["lib/bar.jar"])
    end

    it 'constructs a new Config object using the path to the DSpace installation' do
      dspace_dir_path = '/foo/bar'
      new_config = DSpace::Config.new(dspace_dir_path)

      expect(new_config).not_to be_nil
      expect(new_config.dspace_dir).to eq(dspace_dir_path)
      expect(new_config.dspace_cfg).to eq("#{dspace_dir_path}/config/dspace.cfg")
    end

    context "when the directory for the DSpace installation does not exist" do
      before do
        allow(File).to receive(:join).and_call_original
      end

      it 'raises an error' do
        dspace_dir_path = '/foo/bar'
        new_config = DSpace::Config.new(dspace_dir_path)

        expect { new_config }.to raise_error(StandardError)
      end
    end
  end
end
