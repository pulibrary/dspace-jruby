module DSpaceObjMixin
  def self.included(base)

    def base.list(params)
      return DSpaceObj.get_list(PATH, self, params)
    end

    def base.find_by_id(id)
      return DSpaceObj.get_one("#{PATH}/#{id}", self)
    end

  end

end




