#!/usr/bin/env jruby
require 'dspace'

class DWorkflowItem
  def self.findAll(obj)
    java_import org.dspace.workflow.WorkflowItem
    if (obj.getType == DSpace::COLLECTION)
      return WorkflowItem.findByCollection(DSpace.context, obj)
    elsif   (obj.getType == DSpace::COMMUNITY) then
      flows = []
      obj.getCollections.each do |col|
        flows += findAll(col)
      end
      return flows
    end
    return []
  end

end