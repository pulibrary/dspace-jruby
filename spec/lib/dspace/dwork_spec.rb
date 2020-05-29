describe DWork do
  describe '.findAll' do
  ##
  # Returns all instances of klass if the obj parameter is nil, otherwise
  # all instances of klass associated with the the given obj.
  #
  # @param klass [org.dspace.workflow.WorkflowItem, org.dspace.workflow.WorkspaceItem]
  # @param obj [nil, org.dspace.content.Item, org.dspace.content.Collection, or org.dspace.content.Community]
  # @return [Array<org.dspace.content.Item, org.dspace.content.Collection, or org.dspace.content.Community>] all
  #   obj associated with given limitations.
  end
end

class DWorkflowItem
  describe '.find' do
  ##
  # Find org.dspace.workflow.WorkflowItem from an id
  #
  # @param id [Integer] search id
  # @return [nil, org.dspace.workflow.WorkflowItem] the item or nil if not found
  end

  describe '.findAll' do
  # Retrieves all WorkflowItems related to this object
  # @note returns all instances of org.dspace.workflow.WorkflowItem if the obj parameter is nil, otherwise
  #   all instances of org.dspace.workflow.WorkflowItem associated with the the given obj
  # @param obj [org.dspace.context.DSpaceObject]
  # @return [Array<DWork>]
  end

end

describe DWorkspaceItem do
  describe '.find' do
  ##
  # Find org.dspace.workflow.WorkspaceItem from an id
  #
  # @param id [Integer] search id
  # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
  # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/WorkspaceItem.java
  end

  describe '.findByNetId' do
  ##
  # Find org.dspace.workflow.WorkspaceItem from a netid or email
  #
  # @param netid_or_email [String] netid or email address
  # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
  end

  describe '.findAll' do
  ##
  # Return all instances of org.dspace.workflow.WorkspaceItem if the obj
  #   parameter is nil, otherwise all instances of WorkspaceItem associated with
  #   the given obj
  #
  # @param obj [nil, Object] Dspace object that limits the search. No limits if
  #   nil.
  end

end
