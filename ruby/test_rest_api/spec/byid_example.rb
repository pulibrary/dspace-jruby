RSpec.shared_examples "byid" do |klass|

  it "#{klass}_by_id" do
    obj = klass.list({})
    expect(obj.is_a?(Array)).to be true
    if (obj.count > 0) then
      one = obj[0]
      the_one = klass.find_by_id(one.attributes['id']);
      expect(one.attributes).to eq(the_one.attributes)
    else
      raise "not enough #{klass} objects for test case"
    end
  end

end