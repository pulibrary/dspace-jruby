class DCollection < DSO

  def self.all()
    java_import org.dspace.content.Collection;
    return Collection.findAll(Dscriptor.context)
  end

  def self.findAll(name)
    java_import org.dspace.content.Collection;
    self.all.select do |c|
      c.getName == name
    end
  end


end