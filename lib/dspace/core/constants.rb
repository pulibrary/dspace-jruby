# frozen_string_literal: true

module DSpace
  module Core
    # Transforms constants to strings, corresponding to those defined in org.dspace.core.Constants
    class Constants
      BITSTREAM = 0 # BITSTREAM type object ID
      BUNDLE = 1 # BUNDLE type object ID
      ITEM = 2 # ITEM type object ID
      COLLECTION = 3 # COLLECTION type object ID
      COMMUNITY = 4 # COMMUNITY type object ID
      SITE = 5 # SITE type object ID
      GROUP = 6 # GROUP type object ID
      EPERSON = 7 # EPERSON type object ID

      READ = 0 # READ type action ID
      WRITE = 1 # WRITE type action ID
      DELETE = 2 # DELETE type action ID
      ADD = 3 # ADD type action ID
      REMOVE = 4 # REMOVE type action ID
      WORKFLOW_STEP_1 = 5 # WORKFLOW_STEP_1 type action ID
      WORKFLOW_STEP_2 = 6 # WORKFLOW_STEP_2 type action ID
      WORKFLOW_STEP_3 = 7 # WORKFLOW_STEP_3 type action ID
      WORKFLOW_ABORT = 8 # WORKFLOW_ABORT type action ID
      DEFAULT_BITSTREAM_READ = 9 # DEFAULT_BITSREAM_READ type action ID
      DEFAULT_ITEM_READ = 10 # DEFAULT_ITEM_READ type action ID
      ADMIN = 11 # ADMIN type action ID

      # Return the corresponding type string for an object id
      #
      # @param obj_type_id [Integer] integer 0-7
      # @return [String] the name of the object
      def self.typeStr(obj_type_id)
        type_text = org.dspace.core.Constants.typeText[obj_type_id]
        type_text.capitalize
      end

      # Return the corresponding type string for an action id
      #
      # @param action_id [Integer] integer 0-11
      # @return [String] the name of the action
      def self.actionStr(action_id)
        org.dspace.core.Constants.actionText[action_id]
      end
    end
  end
end
