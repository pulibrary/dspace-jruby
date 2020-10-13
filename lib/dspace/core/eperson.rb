# frozen_string_literal: true

module DSpace
  module Core
    ##
    # This class wraps an org.dspace.eperson.EPerson object
    class EPerson
      java_import(org.dspace.eperson.EPerson)

      include ObjectBehavior
      include DSpaceObjectBehavior

      def self.model_class
        Java::OrgDspaceEperson::EPerson
      end

      ##
      # Collect all Eperson objects from Dspace context
      #
      # @return [Array<org.dspace.eperson.Eperson>]
      def self.all
        model_class.findAll(DSpace.context, 1)
      end

      ##
      # Find the EPerson object from netid, email, or id
      #
      # @param netid_email_or_id [String, Integer] the netid (String), email
      #   (String), or id (Integer) to search with
      # @return [org.dspace.eperson.EPerson, nil] the corresponding object or nil if
      #   it could not be found
      def self.find(netid_email_or_id)
        raise 'must give a netid_or_email value' unless netid_email_or_id

        if netid_email_or_id.is_a?(String)
          # ?? these functions are elsewhere
          return model_class.findByNetid(DSpace.context, netid_email_or_id) || model_class.findByEmail(DSpace.context, netid_email_or_id)
        end

        model_class.find(DSpace.context, netid_email_or_id)
      end

      ##
      # Create an org.dspace.eperson.EPerson with the given netid, name and email.
      #   The EPerson is not committed to the database.
      #
      # @param netid [String] institutional netid
      # @param first [String] first name
      # @param last [String] last name
      # @param email [String] email address
      # @return [org.dspace.eperson.EPerson] the newly created person
      def self.create(netid, first, last, email)
        raise 'must give a netid value' unless netid
        raise 'must give a first and last name' unless first && last

        p = self.class.model_class.findByNetid(DSpace.context, netid)

        raise "netid #{netid} already in use" unless p.nil?

        @dso = self.class.model_class.create(DSpace.context)
        @dso.first_name = first
        @dso.last_name = last
        @dso.netid = netid
        @dso.email = email
        @dso.canLogIn = true
        @dso.update

        puts "Created #{@dso}"

        @dso
      end

      ##
      # Return all groups where this user is a member
      #
      # @return [Array<org.dspace.eperson.Group>] Array of groups
      def groups
        Group.model_class.allMemberGroups(DSpace.context, @obj)
      end

      ##
      # View string representation
      #
      # @return [String] person object represented as a string
      def inspect
        return 'nil' if @obj.nil?

        describe = @obj.getNetid || @obj.getEmail || @obj.getID

        "#<#{self.class.name}:#{describe}>"
      end
    end
  end
end
