class DBitstream
  include DSO

  def self.all()
    java_import org.dspace.content.Bitstream;
    return Bitstream.findAll(DSpace.context)
  end

  def self.find(id)
    java_import org.dspace.content.Bitstream;
    return Bitstream.find(DSpace.context, id)
  end

end