class DSpace < DSO 

  def self.login(netid) 
    Dscriptor.context.setCurrentUser(DEPerson.find(netid))
    return nil
  end

end

