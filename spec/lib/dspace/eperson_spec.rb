# require_relative '../../spec_helper'

describe DEPerson do 
  subject { described_class.new('readyfreddie', 'Freddie', 'Mercury', 'readyfreddie@cambridge.uk') }

  before do
    DEPerson.create('jsbach', 'Johann', 'Bach', 'jsbach@leipzig.de')
    DEPerson.create('mangelou', 'Maya', 'Angelou', 'mangelou@gmail.com')
    DEPerson.create('jsteinbeck', 'John', 'Steinbeck', 'jsteinbeck@stanford.edu')
  end

  after do 
    DSpace.context_renew
  end
  
  describe '.all' do
    it 'returns all EPerson objects from context' do 
      people = DEPerson.all()
      names = people.collect {|x| x.lastName }
      expect(people).not_to be_nil
      expect(people).not_to be_empty
      expect(names).to include('Bach')
    end
  end

  describe '.find' do 
# Find the EPerson object from netid, email, or id
  #
  # @param netid_email_or_id [String, Integer] the netid (String), email 
  #   (String), or id (Integer) to search with
  # @return [org.dspace.eperson.EPerson, nil] the corresponding object or nil if
  #   it could not be found
  end

  describe '.create' do 
# Create an org.dspace.eperson.EPerson with the given netid, name and email.
  #   The EPerson is not committed to the database.
  # 
  # @param netid [String] institutional netid
  # @param first [String] first name
  # @param last [String] last name
  # @param email [String] email address
  # @return [org.dspace.eperson.EPerson] the newly created person

  end

  describe '#groups' do 
##
  # Return all groups where this user is a member
  # 
  # @return [Array<org.dspace.eperson.Group>] Array of groups
  end

  describe '#inspect' do 
  ##
  # View string representation
  # 
  # @return [String] person object represented as a string
  end
end
