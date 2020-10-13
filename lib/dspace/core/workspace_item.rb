# frozen_string_literal: true

module DSpace
  module Core
    ##
    # A class wrapper for org.dspace.workflow.WorkspaceItem
    class WorkspaceItem
      java_import(org.dspace.content.WorkspaceItem)
      include ObjectBehavior

      def self.model_class
        org.dspace.content.WorkspaceItem
      end

      ##
      # Find org.dspace.workflow.WorkspaceItem from an id
      #
      # @param id [Integer] search id
      # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
      # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/WorkspaceItem.java
      def self.find(id)
        model_class.find(DSpace.context, id)
      end

      ##
      # Find org.dspace.workflow.WorkspaceItem from a netid or email
      #
      # @param netid_or_email [String] netid or email address
      # @return [nil, org.dspace.workflow.WorkspaceItem] the item or nil if not found
      def self.findByNetId(netid_or_email)
        person = EPerson.find(netid_or_email)
        model_class.find_by_eperson(DSpace.context, person)
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
        Work.findAll(obj, WorkspaceItem)
      end
    end
  end
end
