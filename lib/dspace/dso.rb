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
    @obj = dobj
    if dobj then
      myname = self.class.name
      raise "can't create #{myname} object from #{@obj}" if myname[1..-1] != @obj.getClass.getName.split('.')[-1]
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

