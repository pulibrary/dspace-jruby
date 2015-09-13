require 'dspace_rest'

class DSpaceObj
  def self.path
    return nil
  end

  def initialize()
    @attributes = {};
  end

  def attributes
    return @attributes
  end

  def []=(key,value)
    @attributes[key] = value
    return value
  end

  def [](key)
    @attributes[key]
  end

  def self.get_list(path, klass, params)
    l = []
    App::REST_API.get(path, params).each do |c|
      obj = klass.new()
      parse(obj, c)
      l << obj
    end
    return l
  end

  def self.get_one(path, klass)
    raw_json =  App::REST_API.get(path, {})
    obj = klass.new()
    parse(obj, raw_json)
    return obj
  end

  def self.parse(object, raw_json)
    raw_json.each do |key, value|
      unless key == 'expand'
        object[key] =  value
      end
    end
  end

end

