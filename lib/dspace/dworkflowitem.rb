#!/usr/bin/env jruby
require 'dspace'

class DWorkflowItem
  def self.findAll(obj)
    java_import org.dspace.workflow.WorkflowItem
    if (obj.nil?) then
      return WorkflowItem.findAll(DSpace.context)
    end
    if (obj.getType == DSpace::COLLECTION)
      return WorkflowItem.findByCollection(DSpace.context, obj)
    elsif (obj.getType == DSpace::COMMUNITY) then
      flows = []
      obj.getAllCollections.each do |col|
        flows += findAll(col)
      end
      return flows
    elsif (obj.getType == DSpace::ITEM) then
      wi = WorkflowItem.findByItem(DSpace.context, obj)
      # to be consistent return array with the unqiue wokflow item
      return [wi] if wi
    end
    # return empty array if no matching workflow items
    return []
  end

end
