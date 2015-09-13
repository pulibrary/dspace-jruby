require "initializer"
require "lister_example"
require "byid_example"
require "has_many_example"

restapi = App::REST_API

RSpec.describe DItem do
  include_examples "listers", DItem
  include_examples "byid", DItem
  include_examples "has_many", DItem, "bitstreams"

end

