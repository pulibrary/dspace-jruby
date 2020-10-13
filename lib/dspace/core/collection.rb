# frozen_string_literal: true

module DSpace
  module Core
    class Collection
      include ObjectBehavior
      include DSpaceObjectBehavior

      # Collect all Collection objects from Dspace context
      #
      # @return [Array<org.dspace.content.Collection>] all Collections
      def self.all
        java_import org.dspace.content.Collection
        Collection.findAll(DSpace.context)
      end

      # Get corresponding Collection object from a given id
      #
      # @param id [Integer] the Collection id
      # @return [nil, org.dspace.content.Collection] either the corresponding
      #   collection object or nil if it couldn't be found.
      def self.find(id)
        java_import org.dspace.content.Collection
        Collection.find(DSpace.context, id)
      end

      # Create and return org.dspace.content.Collection with given name in the
      #   given community
      #
      # @param name [String] the name of the new collection
      # @param community [org.dspace.content.Communiy] the community the collection
      #   should be placed within
      # @return [org.dspace.content.Collection] the newly created collection
      def self.create(name, community)
        java_import org.dspace.content.Collection

        new_col = Collection.create(DSpace.context)
        new_col.setMetadata('name', name)
        new_col.update
        community.addCollection(new_col)
        new_col
      end

      # Return all items listed by the dspace item iterator
      #
      # @return [Array<org.dspace.content.Item>] an array of Item objects
      def items
        items = []
        iter = @obj.items

        while (i = iter.next)
          items << i
        end

        items
      end
    end
  end
end
