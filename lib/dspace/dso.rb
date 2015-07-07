class DSO

  def self.fromString(type_id_or_handle)
    java_import org.dspace.content.DSpaceObject
    DSpaceObject.fromString(Dscriptor.context, type_id_or_handle)
  end

  def self.policies(dso)
    java_import org.dspace.authorize.AuthorizeManager
    pols = AuthorizeManager.getPolicies(Dscriptor.context, dso)
    pols.collect do |p|
      [p.getAction(), p.getEPerson, p.getGroup]
    end
  end

  def self.help
    if (self == DSO)
      klasses = ObjectSpace.each_object(Class).select { |c| c < DSO }
    else
      klasses = [ self ];
    end
    klasses << DSO
    klasses.each do |klass|
      klass.singleton_methods.sort.each do |mn|
        m = klass.method(mn)
        plist = m.parameters.collect { |p|
          if (p[0] == :req) then
            "#{p[1].to_s}"
          else
            "[ #{p[1].to_s} ]"
          end
        }
        puts "#{klass.name}.#{mn.to_s} (#{plist.join(", ")})"
      end
    end
    return nil
  end

end

