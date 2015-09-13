RSpec.shared_examples "listers" do |klass|
  DEFAULT_MAX_INLIST = 100

  it "#{klass}_all" do
    obj = klass.list({})
    expect(obj.is_a?(Array)).to be true
    expect(obj.count <= DEFAULT_MAX_INLIST).to be true
  end

  [0, 1, 5].each do |limit|
    it "#{klass}_get_#{limit}" do
      obj = klass.list({'limit' => limit, 'offset' => 0})
      expect(obj.is_a?(Array)).to be true
      expect(obj.count).to eq(limit)
    end
  end

  [0, 1, 5].each do |offset|
    it "#{klass}_offset_#{offset}" do
      from = klass.list({'limit' => 1, 'offset' => offset})
      expect(from.is_a?(Array)).to be true
      if (from.count > 0) then
        from_zero = klass.list({'limit' => offset + 2, 'offset' => 0})
        expect(from_zero.is_a?(Array)).to be true
        expect(from[0].attributes).to eq(from_zero[offset].attributes)
      else
        raise "not enough #{klass} objects for test case"
      end
    end
  end

end