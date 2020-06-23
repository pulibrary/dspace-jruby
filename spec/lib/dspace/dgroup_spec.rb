##
# This class wraps an org.dspace.eperson.Group object
describe DGroup do
  subject { described_class.find_or_create('english-musicians') }

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
    musicians.addMember(subject)
  end

  after do 
    DSpace.context_renew
  end

  describe '.all' do
    it 'captures all the groups defined in the context' do
      all_groups = DGroup.all
      expect(all_groups.length).to eq(5)
      expect(all_groups).to include Java::OrgDspaceEperson::Group
    end
  end

  describe '.find' do
    it 'gets corresponding Group object from a given id' do
      id = subject.id
      expect(DGroup.find(id)).to eq subject
    end

    it 'gets corresponding Group object from a name' do
      expect(DGroup.find 'english-musicians' ).to eq subject
    end
  end

  describe '.find_or_create' do
    it 'finds a group given its name' do 
      expect(DGroup.find_or_create 'english-musicians').to eq subject
    end

    it 'creates a group if it does not exist' do
      l_before = DGroup.all
      DGroup.find_or_create 'artists'
      l_after = DGroup.all
      expect(l_before.length + 1).to eq(l_after.length)
    end
  end

  describe '#members' do
    it 'returns all members' do
      musicians = DSpace.create(DGroup.find_or_create('musicians'))
      expect(musicians.members.length).to eq 3
    end

    it 'returns both EPerson and Group objects' do
      musicians = DSpace.create(DGroup.find_or_create('musicians'))
      expect(musicians.members).to include Java::OrgDspaceEperson::Group
      expect(musicians.members).to include Java::OrgDspaceEperson::EPerson
    end
  end

  describe '#addMember' do
    it 'adds member to the group' do 
      s = DSpace.create(subject)
      before_l = s.members
      s.addMember(DEPerson.create('ghandel', 'George', 'Handel', 'ghandel@cambridge.uk'))
      after_l = s.members
      expect(before_l.length + 1).to eq after_l.length
    end
  end

  describe '#inspect' do
    it 'returns a string' do
      expect(DSpace.create(subject).inspect).to be_a String
    end
  end
end
