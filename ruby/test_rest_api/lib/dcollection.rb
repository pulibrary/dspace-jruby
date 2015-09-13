require 'dspace_obj'

class DCollection  < DSpaceObj
  PATH = "collections"

  def self.list(params)
    return DSpaceObj.get_list(PATH, self, params)
  end

  def self.find_by_id(id)
    return DSpaceObj.get_one("#{PATH}/#{id}", self)
  end

  def items(params)
    id = self['id'];
    return DSpaceObj.get_list("#{PATH}/#{id}/items", DItem, params)
  end

end

