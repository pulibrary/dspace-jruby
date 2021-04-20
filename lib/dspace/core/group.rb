# frozen_string_literal: true

module DSpace
  module Core
    ##
    # This class wraps an org.dspace.eperson.Group object
    class Group
      java_import(org.dspace.eperson.Group)

      include ObjectBehavior
      include DSpaceObjectBehavior

      ##
      # id of administrator group
      ADMIN_ID = 1

      ##
      # id of anonymous user group
      ANONYMOUS_ID = 0

      def self.model_class
        org.dspace.eperson.Group
      end

      ##
      # Collect all Eperson objects from Dspace context
      #
      # @return [Array<org.dspace.eperson.Group>]
      def self.all
        model_class.findAll(DSpace.context, 1)
      end

      ##
      # Get corresponding Group object from a given id
      #
      # @param name_or_id [String, Integer] the Group id or name
      # @return [nil, org.dspace.eperson.Group] either the corresponding Group
      #   object or nil if it couldn't be found.
      def self.find(name_or_id)
        if name_or_id.instance_of?(String)
          model_class.findByName(DSpace.context, name_or_id)
        else
          model_class.find(DSpace.context, name_or_id)
        end
      end

      ##
      # Find and return the existing group with the given name or create and return
      #   a new group with the given name
      #
      # @param name [String] name of new group
      # @return [org.dspace.eperson.Group] the found or created Group.
      def self.find_or_create(name)
        raise 'must give a name ' unless name

        group = find(name)
        if group.nil?
          group = model_class.create(DSpace.context)
          group.setName(name)
          group.update
          puts "Created #{group.toString}"
        else
          puts "Exists #{group.toString}"
        end
        group
      end

      ##
      # Get EPerson and Groups that are (direct) members of this Group
      #
      # @return [Array<org.dspace.eperson.Group, org.dspace.eperson.EPerson>]
      #   array of members, either Epersons or Groups
      def members
        @model.getMemberGroups.collect { |p| p } + @model.getMembers.collect { |p| p }
      end

      ##
      # Add a member to the group
      #
      # @param group_or_eperson [org.dspace.eperson.EPerson, org.dspace.eperson.Group]
      #   must be a  or Group object
      # @return updated self
      def addMember(group_or_eperson)
        raise 'must give non nil group_or_eperson' if group_or_eperson.nil?

        @model.addMember(group_or_eperson)
        @model.update
        @model
      end

      ##
      # View string representation of object
      #
      # @return [String] string representation
      def inspect
        return 'nil' if @model.nil?

        "#<#{self.class.name}:#{@model.getName}>"
      end

      def name
        @model.getName
      end
    end
  end
end
