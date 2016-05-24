#!/usr/bin/env jruby
require 'dspace'

class DWorkspaceItem
  def self.findAll(obj)
    java_import org.dspace.content.WorkspaceItem
    if (obj.nil?) then
      return WorkspaceItem.findAll(DSpace.context)
    end
    if (obj.getType == DSpace::COLLECTION)
      return  WorkspaceItem.findByCollection(DSpace.context, obj)
    elsif (obj.getType == DSpace::COMMUNITY) then
      wsis = []
      obj.getAllCollections.each do |col|
        wsis += findAll(col)
      end
      return wsis
    elsif (obj.getType == DSpace::ITEM) then
      wi = WorkspaceItem.findByItem(DSpace.context, obj)
      # to be consistent return array with the unqiue wokflow item
      return [wi] if wi
    end
    # return empty array if no matching workspace items
    return []
  end

end
