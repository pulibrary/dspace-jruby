require 'dspace_rest'

class DSpaceObj

  def initialize(type)
    @type = type
    @obj = nil
  end

  def type
    return @type
  end

  def obj
    return @obj
  end

  def  obj=(o)
    @obj = o
  end

  def self.list(type, params)
    return App::REST_API.get("/" + type, params)
  end

  def self.get(type, id)
    return App::REST_API.get("/#{type}/#{id}", {})
  end
end

