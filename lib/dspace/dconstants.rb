##
# This class wraps an org.dspace.content.Community object
class DConstants

  ##
  # constants corresponding to those defined in org.dspace.core.Constants
  BITSTREAM = 0;
  BUNDLE = 1;
  ITEM = 2;
  COLLECTION = 3;
  COMMUNITY = 4;
  SITE = 5;
  GROUP = 6;
  EPERSON = 7;

  READ = 0;
  WRITE = 1;
  DELETE = 2;
  ADD = 3;
  REMOVE = 4;
  WORKFLOW_STEP_1 = 5;
  WORKFLOW_STEP_2 = 6;
  WORKFLOW_STEP_3 = 7;
  WORKFLOW_ABORT = 8;
  DEFAULT_BITSTREAM_READ = 9;
  DEFAULT_ITEM_READ = 10;
  ADMIN = 11;

  
  ##
  # returns nil or the org.dspace.content.Community object with the given id
  #
  # id must be an integer
  def self.typeStr(obj_type_id)
    return org.dspace.core.Constants.typeText[obj_type_id].capitalize
  end

  ##
  # return String for given action_id
  def self.actionStr(action_id)
      return org.dspace.core.Constants.actionText[action_id]
  end

end
