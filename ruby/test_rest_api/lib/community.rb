require 'dspace_obj'
require 'initializer'

class DCommunity < DSpaceObj
  def initialize()
    super("communities")
  end

  def self.list(params)
    return App::REST_API.get("/communities", params)
  end

  def self.find_by_id(id)
    me = DCommunity.new()
    me.obj = DSpaceObj.get(me.type, id)
    return me
  end
end

