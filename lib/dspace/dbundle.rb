class DBundle
  include DSO

  def self.find(id)
    java_import org.dspace.content.Bundle;
    return Bundle.find(DSpace.context, id)
  end
end