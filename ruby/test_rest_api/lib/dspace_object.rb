require 'dspace_rest'

class DSpaceObject

  def self.list(type, params)
    return App::REST_API.get("/" + type, params)
  end

end

