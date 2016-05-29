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
    if (obj.getType == DSpace::COLLECTION)
      return klass.findByCollection(DSpace.context, obj)
    elsif (obj.getType == DSpace::COMMUNITY) then
      wsis = []
      obj.getAllCollections.each do |col|
        wsis += findAll(col)
      end
      return wsis
    elsif (obj.getType == DSpace::ITEM) then
      wi = klass.findByItem(DSpace.context, obj)
      # to be consistent return array with the unqiue wokflow item
      return [wi] if wi
    end
    # return empty array if no matching workspace items
    return []
  end

end

class DWorkflowItem

  ##
  # returns all instances of org.dspace.workflow.WorkflowItem if the obj parameter is nil, otherwise
  # all instances of org.dspace.workflow.WorkflowItem associated with the the given obj
  def self.findAll(obj)
    java_import org.dspace.workflow.WorkflowItem
    return DWork.findAll(obj, WorkflowItem)
  end

end

class DWorkspaceItem

  ##
  # returns all instances of org.dspace.workflow.WorkspaceItem if the obj parameter is nil, otherwise
  # all instances of org.dspace.workflow.WorkspaceItem associated with the the given obj
  def self.findAll(obj)
    java_import org.dspace.workflow.WorkspaceItem
    return DWork.findAll(obj, WorkspaceItem)
  end

end
