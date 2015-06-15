
module Dscriptor
  module Mixins
    def with_dso(arg, klass = nil)
      obj = if String === arg
        HandleManager.resolve_to_object(context, arg)
      elsif Integer === arg
        klass.find(context, arg)
      else arg
      end
      block_given? ? yield(obj) : obj
    end

    def with_community(arg, &blk);  with_dso(arg, Community, &blk); end
    def with_collection(arg, &blk); with_dso(arg, Collection, &blk); end
    def with_item(arg, &blk);       with_dso(arg, Item, &blk); end

    def dso_parents(obj)
      moms = [];
      p = obj.getParentObject()
      while p do
        moms << p;
        p = p.getParentObject();
      end
      return moms;
    end
  end
end
