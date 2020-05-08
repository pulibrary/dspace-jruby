# Module for methods common to the DWorkflow and DWorkSpace Classes
module DWork

  ##
  # Returns all instances of klass if the obj parameter is nil, otherwise
  # all instances of klass associated with the the given obj.
  #
  # @param klass [org.dspace.workflow.WorkflowItem, org.dspace.workflow.WorkspaceItem]
  # @param obj [nil, org.dspace.content.Item, org.dspace.content.Collection, or org.dspace.content.Community]
  # @return [Array<org.dspace.content.Item, org.dspace.content.Collection, or org.dspace.content.Community>] all
  #   obj associated with given limitations.
  def self.findAll(obj, klass)
    if (obj.nil?) then
      return klass.findAll(DSpace.context)
    end
    if (obj.getType == DConstants::COLLECTION)
      return klass.findByCollection(DSpace.context, obj)
    elsif (obj.getType == DConstants::COMMUNITY) then
      wsis = []
      obj.getAllCollections.each do |col|
        wsis += findAll(col, klass)
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

##
# A class wrapper for org.dspace.workflow.WorkflowItem
# @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/workflow/WorkflowItem.java
class DWorkflowItem
  include DSO

  ##
  # Find org.dspace.workflow.WorkflowItem from an id
  #
  # @param id [Integer] search id
  # @return [nil, org.dspace.workflow.WorkflowItem] the item or nil if not found
  def self.find(id)
    java_import org.dspace.workflow.WorkflowItem
    return WorkflowItem.find(DSpace.context, id)
  end

  # Retrieves all WorkflowItems related to this object
  # @note returns all instances of org.dspace.workflow.WorkflowItem if the obj parameter is nil, otherwise
  #   all instances of org.dspace.workflow.WorkflowItem associated with the the given obj
  # @param obj [org.dspace.context.DSpaceObject]
  # @return [Array<DWork>]
  def self.findAll(obj)
    java_import org.dspace.workflow.WorkflowItem
    return DWork.findAll(obj, WorkflowItem)
  end

end

##
# A class wrapper for org.dspace.workflow.WorkspaceItem
class DWorkspaceItem
  include DSO

  ##
  # Find org.dspace.workflow.WorkspaceItem from an id
  #
  # @param id [Integer] search id
  # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/WorkspaceItem.java
  def self.find(id)
    java_import org.dspace.content.WorkspaceItem
    return WorkspaceItem.find(DSpace.context, id)
  end

  ##
  # Find org.dspace.workflow.WorkspaceItem from a netid or email
  #
  # @param netid_or_email [String] netid or email address
  # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
  def self.findByNetId(netid_or_email)
    java_import org.dspace.content.WorkspaceItem
    person = DEPerson.find(netid_or_email)
    return WorkspaceItem.find_by_eperson(DSpace.context, person)
  end

  ##
  # Return all instances of org.dspace.workflow.WorkspaceItem if the obj
  #   parameter is nil, otherwise all instances of WorkspaceItem associated with
  #   the given obj
  #
  # @param obj [nil, Object] Dspace object that limits the search. No limits if
  #   nil.
  def self.findAll(obj)
    java_import org.dspace.content.WorkspaceItem
    return DWork.findAll(obj, WorkspaceItem)
  end

end
