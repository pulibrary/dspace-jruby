##
# Helper module for DWorkflow and DWorkSpace
module DWork

  ## 
  # returns all instances of klass if the obj parameter is nil, otherwise
  # all instances of klass associated with the the given obj
  #
  # klass:: must be  org.dspace.workflow.WorkflowItem and org.dspace.workflow.WorkspaceItem
  # obj:: nil or instances of org.dspace.content.Item, Collection, or Community
  def self.findAll(obj, klass)
    if (obj.nil?) then
      return klass.findAll(DSpace.context)
    end
    if (obj.getType == DConstants::COLLECTION)
      return klass.findByCollection(DSpace.context, obj)
    elsif (obj.getType == DConstants::COMMUNITY) then
      wsis = []
      obj.getAllCollections.each do |col|
        wsis += findAll(col)
      end
      return wsis
    elsif (obj.getType == DConstants::ITEM) then
      wi = klass.findByItem(DSpace.context, obj)
      # to be consistent return array with the unqiue wokflow item
      return [wi] if wi
    elsif (obj.getType == DConstants::EPERSON) then
      wi = klass.findByEPerson(DSpace.context, obj)
    end
    # return empty array if no matching workspace items
    return []
  end

end

class DWorkflowItem
  include DSO

  ##
  # find org.dspace.workflow.WorkflowItem
  #
  # id must be an integer
  def self.find(id)
    java_import org.dspace.workflow.WorkflowItem
    return WorkflowItem.find(DSpace.context, id)
  end


  ##
  # returns all instances of org.dspace.workflow.WorkflowItem if the obj parameter is nil, otherwise
  # all instances of org.dspace.workflow.WorkflowItem associated with the the given obj
  def self.findAll(obj)
    java_import org.dspace.workflow.WorkflowItem
    return DWork.findAll(obj, WorkflowItem)
  end

end

class DWorkspaceItem
  include DSO

  ##
  # find org.dspace.workflow.WorkspaceItem
  #
  # id must be an integer
  def self.find(id)
    java_import org.dspace.content.WorkspaceItem
    return WorkspaceItem.find(DSpace.context, id)
  end

  ##
  # returns all instances of org.dspace.workflow.WorkspaceItem if the obj parameter is nil, otherwise
  # all instances of org.dspace.workflow.WorkspaceItem associated with the the given obj
  def self.findAll(obj)
    java_import org.dspace.content.WorkspaceItem
    return DWork.findAll(obj, WorkspaceItem)
  end

end
