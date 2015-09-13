require 'dspace_obj'

class DBitstream  < DSpaceObj
  PATH = "bitstreams"

  def self.list(params)
    return DSpaceObj.get_list(PATH, self, params)
  end

  def self.find_by_id(id)
    return DSpaceObj.get_one("#{PATH}/#{id}", self)
  end

end

