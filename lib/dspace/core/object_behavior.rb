# frozen_string_literal: true

module DSpace
  module Core
    # Module containing functionality shared between entities persisted in the DSpace kernel
    module ObjectBehavior
      # Instanciates a wrapper object for the given dobj, which must derive from
      #   org.dspace.content.DSpaceObject. The wrapper object's class must be
      #   compatible with the type of the given dobj.
      # @param dobj [Object] an object from org.dspace.content.DSpaceObject
      # @see https://github.com/DSpace/DSpace/blob/dspace-5.5/dspace-api/src/main/java/org/dspace/content/DSpaceObject.java
      def initialize(dobj)
        @obj = dobj
        @model = @obj
      end

      # Accessor for the decorated org.dspace.content.DSpaceObject
      # @return [org.dspace.content.DSpaceObject]
      def dso
        @obj
      end

      # View string representation
      #
      # @return [String] String representation
      def inspect
        return 'nil' if @obj.nil?

        "#<#{self.class.name}:#{@obj.getID}>"
      end
    end
  end
end
