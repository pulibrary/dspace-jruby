class DBitstream
include DSO

  def self.all()
    java_import org.dspace.content.Bitstream;
    return Bitstream.findAll(DSpace.context)
  end

end