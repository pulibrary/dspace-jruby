require 'dspace_obj'

class DItem  < DSpaceObj
  PATH = "items"

  def self.list(params)
    return DSpaceObj.get_list(PATH, self, params)
  end

  def self.find_by_id(id)
    return DSpaceObj.get_one("#{PATH}/#{id}", self)
  end

end

