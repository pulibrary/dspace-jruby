require "initializer"

restapi = App::REST_API

if (false) then
  email = ask "email: ";
  pwd = ask "password ";
  restapi.login(email, pwd)


  RSpec.shared_examples "collections" do
    it "is empty when first created" do
      expect(described_class.new).to be_empty
    end
  end

end


RSpec.describe "Listers" do
  DEFAULT_MAX_INLIST = 100

  [DCommunity, DCollection, DItem, DBitstream].each do |klass|
    it "#{klass}_all" do
      obj = klass.list({})
      expect(obj.is_a?(Array)).to be true
      expect(obj.count <= DEFAULT_MAX_INLIST).to be true
    end
  end

  [DCommunity, DCollection, DItem, DBitstream].each do |type|
    [0, 1, 5].each do |limit|
      it "#{type}_get_#{limit}" do
        obj = type.list({'limit' => limit, 'offset' => 0})
        expect(obj.is_a?(Array)).to be true
        expect(obj.count).to eq( limit)
      end
    end
  end

  [DCommunity, DCollection, DItem, DBitstream].each do |type|
    [0, 1, 5].each do |offset|
      it "#{type}_offset_#{offset}" do
        from = type.list({'limit' => 1, 'offset' => offset})
        expect(from.is_a?(Array)).to be true
        if (from.count > 0) then
          from_zero = type.list({'limit' => offset + 2, 'offset' => 0})
          expect(from_zero.is_a?(Array)).to be true
          expect(from[0].attributes).to eq( from_zero[offset].attributes)
        else
          raise "not enough #{type} objects for test case"
        end
      end
    end
  end

end


