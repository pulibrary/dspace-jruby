# frozen_string_literal: true

module DSpace
  module Core
    # Module for methods common to the DWorkflow and DWorkSpace Classes
    module Work
      ##
      # Returns all instances of klass if the obj parameter is nil, otherwise
      # all instances of klass associated with the the given obj.
      #
      # @param klass [org.dspace.workflow.WorkflowItem, org.dspace.workflow.WorkspaceItem]
      # @param obj [nil, org.dspace.content.Item, org.dspace.content.Collection, or org.dspace.content.Community]
      # @return [Array<org.dspace.content.Item, org.dspace.content.Collection, or org.dspace.content.Community>] all
      #   obj associated with given limitations.
      def self.findAll(obj, klass)
        return klass.findAll(DSpace.context) if obj.nil?

        case obj.getType
        when DConstants::COLLECTION
          return klass.findByCollection(DSpace.context, obj)
        when DConstants::COMMUNITY
          wsis = []
          obj.getAllCollections.each do |col|
            wsis += findAll(col, klass)
          end
          return wsis
        when DConstants::ITEM
          wi = klass.findByItem(DSpace.context, obj)
          # to be consistent return array with the unqiue wokflow item
          return [wi] if wi
        when DConstants::EPERSON
          wi = klass.findByEPerson(DSpace.context, obj)
        end

        # return empty array if no matching workspace items
        []
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
        WorkflowItem.find(DSpace.context, id)
      end

      # Retrieves all WorkflowItems related to this object
      # @note returns all instances of org.dspace.workflow.WorkflowItem if the obj parameter is nil, otherwise
      #   all instances of org.dspace.workflow.WorkflowItem associated with the the given obj
      # @param obj [org.dspace.context.DSpaceObject]
      # @return [Array<DWork>]
      def self.findAll(obj)
        java_import org.dspace.workflow.WorkflowItem
        DWork.findAll(obj, WorkflowItem)
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
        WorkspaceItem.find(DSpace.context, id)
      end

      ##
      # Find org.dspace.workflow.WorkspaceItem from a netid or email
      #
      # @param netid_or_email [String] netid or email address
      # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
      def self.findByNetId(netid_or_email)
        java_import org.dspace.content.WorkspaceItem
        person = DEPerson.find(netid_or_email)
        WorkspaceItem.find_by_eperson(DSpace.context, person)
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
        DWork.findAll(obj, WorkspaceItem)
      end
    end
  end
end
