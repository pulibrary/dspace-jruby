require 'dspace_obj'
require 'dcollection'

class DCommunity < DSpaceObj
  PATH = "communities"

  def self.list(params)
    return DSpaceObj.get_list(PATH, self, params)
  end

  def self.find_by_id(id)
    return DSpaceObj.get_one("#{PATH}/#{id}", self)
  end

  def collections(params)
    id = self['id'];
    return DSpaceObj.get_list("#{PATH}/#{id}/collections", DCollection, params)
  end

end

