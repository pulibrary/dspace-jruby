##
# This class wraps an org.dspace.eperson.Group object
describe DGroup do

  describe '.all' do
  ##
  # Collect all Eperson objects from Dspace context
  # 
  # @return [Array<org.dspace.eperson.Group>]
  end

  describe '.find' do
##
  # Get corresponding Group object from a given id
  #
  # @param name_or_id [String, Integer] the Group id or name
  # @return [nil, org.dspace.eperson.Group] either the corresponding Group 
  #   object or nil if it couldn't be found.
  end

  describe '.find_or_create' do
  ##
  # Find and return the existing group with the given name or create and return 
  #   a new group with the given name
  #
  # @param name [String] name of new group 
  # @return [org.dspace.eperson.Group] the found or created Group.
  end

  describe '#members' do
  ##
  # Get EPerson and Groups that are (direct) members of this Group
  # 
  # @return [Array<org.dspace.eperson.Group, org.dspace.eperson.EPerson>] 
  #   array of members, either Epersons or Groups
  end

  describe '#addMember' do
##
  # Add a member to the group
  #
  # @param group_or_eperson [org.dspace.eperson.EPerson, org.dspace.eperson.Group]
  #   must be a  or Group object
  # @return updated self
  end

  describe '#inspect' do
      ##
  # View string representation of object
  # 
  # @return [String] string representation
  end
end
