require "initializer"
require "lister_example"
require "byid_example"
require "has_many_example"

RSpec.describe DCommunity do
  include_examples "listers", DCommunity
  include_examples "byid", DCommunity
  include_examples "has_many", DCommunity, "collections"

end

