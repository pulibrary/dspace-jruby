# frozen_string_literal: true

module DSpace
  module Core
    # This class wraps an org.dspace.content.Community object
    # @see https://github.com/DSpace/DSpace/blob/dspace-5.3/dspace-api/src/main/java/org/dspace/content/Community.java
    class Community
      java_import(org.dspace.content.Community)

      include ObjectBehavior
      include DSpaceObjectBehavior

      # Collect all Community objects from Dspace context
      #
      # @return [Array<org.dspace.content.Community>]
      def self.all
        Community.findAll(DSpace.context)
      end

      # Get corresponding Community object from a given id
      #
      # @param id [Integer] the Community id
      # @return [nil, org.dspace.content.Community] either the corresponding
      #   Community object or nil if it couldn't be found.
      def self.find(id)
        java_import org.dspace.content.Community
        Community.find(DSpace.context, id)
      end

      # Create and return org.dspace.content.Community with given name in the given
      #   community
      #
      # @param name [String] the name of the new Community
      # @return [org.dspace.content.Community] the newly created Community
      def self.create(name)
        comm = Community.create(nil, DSpace.context)
        comm.setMetadata('name', name)
        comm.update
        comm
      end

      # Retrieve all child Collections and Collections within Sub-Communities for this object
      # @return [Array<org.dspace.context.Collections>]
      def getCollections
        Community.getCollections(dso)
      end

      ##
      # Get all collections from within given community and subcommunities
      #
      # @param com [org.dspace.content.Community]
      # @return [Array<org.dspace.content.Collection>]
      def self.getCollections(comms)
        colls = []
        comms = [comms] unless comms.is_a? Array
        comms.each do |comm|
          colls += comm.getCollections.collect { |coll| coll }
          colls += getCollections(comm.getSubcommunities.collect { |sc| sc })
        end
        colls
      end
    end
  end
end
