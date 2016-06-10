##
# This module contains methods to be included by classes that wrap objects 
# that derive from org.dspace.content.DSpaceObject 
require 'json'

module DSO

  ## 
  # instanciates a wrapper object for the given dobj, which must derive from org.dspace.content.DSpaceObject
  # 
  # the wrapper object's class must be compatible with the type of the given dobj 
  def initialize(dobj)
    #TODO compare
    @obj = dobj
    if dobj then
      #puts self.class.name
      #puts dobj.class.name
    end
  end

  def dso
    return @obj
  end

  def inspect
    return "nil" if @obj.nil?
    return "#<#{self.class.name}:#{@obj.getID}>"
  end

end

