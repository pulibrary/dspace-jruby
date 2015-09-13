RSpec.shared_examples "has_many" do |klass, method|

  it "#{klass}_has_many_#{method}" do
    obj = klass.list({})
    expect(obj.is_a?(Array)).to be true
    if (obj.count > 0) then
      the_one = klass.find_by_id(obj[0].attributes['id']);
      subs = the_one.send method, {}
      expect(subs.is_a?(Array)).to be true
    else
      raise "not enough #{klass} objects for test case"
    end
  end

end