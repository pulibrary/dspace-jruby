# require_relative '../../spec_helper'

describe DEPerson do 
  subject { described_class.create('readyfreddie', 'Freddie', 'Mercury', 'readyfreddie@cambridge.uk') }

  before do
    DSpace.login('admin@localhost')
    bach = DEPerson.create('jsbach', 'Johann', 'Bach', 'jsbach@leipzig.de')
    angelou = DEPerson.create('mangelou', 'Maya', 'Angelou', 'mangelou@gmail.com')
    steinbeck = DEPerson.create('jsteinbeck', 'John', 'Steinbeck', 'jsteinbeck@stanford.edu')
    writers = DSpace.create(DGroup.find_or_create('writers'))
    musicians = DSpace.create(DGroup.find_or_create('musicians'))
    writers.addMember(steinbeck)
    writers.addMember(angelou)
    musicians.addMember(angelou)
    musicians.addMember(bach)
  end

  after do 
    DSpace.context_renew
  end

  describe '.all' do
    it 'returns all EPerson objects from context' do 
      people = DEPerson.all()
      
      expect(people).not_to be_nil
      expect(people.length).to eq(4)

      names = people.collect {|x| x.lastName }
      expect(names).to include 'Bach'
    end
  end

  describe '.find' do 
    it 'returns nil if person is not found' do
      cant_find = DEPerson.find('Waldo')
      expect(cant_find).to be_nil
    end

    it 'returns a Java EPerson object' do
      searched = DEPerson.find(subject.email)
      expect(searched ).to be_a Java::OrgDspaceEperson::EPerson
    end
    
    it 'returns the object of the corresponding person' do
      searched = DEPerson.find(subject.email)
      expect(searched.lastName).to eq 'Mercury'
    end
  end

  describe '.create' do 
    it 'throws error if netid is already in use' do
      expect { DEPerson.create('jsbach', 'Johann', 'Bach', 'jsbach@leipzig.de') }.to raise_error
    end
  end

  describe '#groups' do
    it 'returns the one group that the subject belongs to' do
      expect(DSpace.create(subject).groups.length).to eq 1
    end

    it 'returns multiple groups when the person belongs to multiple' do
      angelou = DSpace.create(DEPerson.find('mangelou@gmail.com'))
      expect(angelou.groups.length).to eq 3
    end
  end

  describe '#inspect' do
    it 'returns a string' do
      expect(DSpace.create(subject).inspect).to be_a String
    end
  end
end
