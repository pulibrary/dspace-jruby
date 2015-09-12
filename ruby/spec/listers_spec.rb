require 'dspace_rest'
require 'rspec'
require 'net/http'

restapi = DSpaceRest.new("http://localhost:8080/rest")
if (false) then
  email = ask "email: ";
  pwd = ask "password ";
  restapi.login(email, pwd)

  restapi.list("communities", {limit: 1})
  puts restapi.res2obj.count


end


RSpec.describe "Listers" do
  DEFAULT_MAX_INLIST = 100

  ["communities", "collections", "items", "bitstreams"].each do |type|
    it "#{type}_all" do
      obj = restapi.list(type, {})
      expect(obj.is_a?(Array)).to be true
      expect(obj.count <= DEFAULT_MAX_INLIST).to be true
    end
  end

  ["communities", "collections", "items", "bitstreams"].each do |type|
    [0, 1, 5].each do |limit|
      it "#{type}_get_#{limit}" do
        obj = restapi.list(type, {'limit' => limit, 'offset' => 0})
        expect(obj.is_a?(Array)).to be true
        expect(obj.count).to eq( limit)
      end
    end
  end

  ["communities", "collections", "items", "bitstreams"].each do |type|
    [0, 1, 5].each do |offset|
      it "#{type}_offset_#{offset}" do
        from = restapi.list(type, {'limit' => 1, 'offset' => offset})
        expect(from.is_a?(Array)).to be true
        if (from.count > 0) then
          from_zero = restapi.list(type, {'limit' => offset + 2, 'offset' => 0})
          expect(from_zero.is_a?(Array)).to be true
          expect(from[0]).to eq( from_zero[offset])
        else
          raise "not enough #{type} objects for test case"
        end
      end
    end
  end

end


