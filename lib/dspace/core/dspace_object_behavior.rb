# frozen_string_literal: true

module DSpace
  module Core
    # Module containing functionality shared between DSpaceObject child classes
    module DSpaceObjectBehavior
      # Collect all parents, grandparents, etc. from Dspace object
      #
      # @return [Array<DSO>] All parent objects
      def parents
        nodes = []
        p = @obj.getParentObject

        while p
          nodes << p
          p = p.getParentObject
        end

        nodes
      end

      # Determine if object is within given Dspace object
      #
      # @param dobj [DSO] the Dspace object in question
      # @return [Boolean] is the parameter a parent of our object?
      def isInside(dobj)
        return false if dobj.nil?

        p = @obj
        while p
          return true if p == dobj

          p = p.getParentObject
        end

        false
      end

      # Collect all the policies from Dspace object
      #
      # @return [Array<Hash>] an array of policies, defined by Action, Eperson, and Group
      def policies
        java_import(org.dspace.authorize.AuthorizeManager)

        pols = AuthorizeManager.getPolicies(DSpace.context, @obj)

        pols.collect do |p|
          pp = p.getEPerson
          pg = p.getGroup
          hsh = {
            action: p.getAction
          }
          hsh[:person] = pp.getName if pp
          hsh[:group] = pg.getName if pg

          hsh
        end
      end

      # Collect all metadata from Dspace object
      #
      # @return [Array<DMetadataField, String>] Metadata object and metadata name.
      def getMetaDataValues
        java_import(org.dspace.content.MetadataSchema)
        java_import(org.dspace.content.MetadataField)
        java_import(org.dspace.storage.rdbms.DatabaseManager)
        java_import(org.dspace.storage.rdbms.TableRow)

        sql = 'SELECT MV.metadata_field_id,  MV.text_value FROM METADATAVALUE MV ' \
              " WHERE RESOURCE_TYPE_ID = #{@obj.getType} AND RESOURCE_ID = #{@obj.getID}"
        tri = DatabaseManager.queryTable(DSpace.context, 'MetadataValue', sql)

        mvs = []
        while (iter = tri.next)
          field = MetadataField.find(DSpace.context, iter.getIntColumn('metadata_field_id'))
          mvs << [DMetadataField.new(field), iter.getStringColumn('text_value')]
        end

        tri.close

        mvs
      end
    end
  end
end
