require "initializer"
require "lister_example"
require "byid_example"
require "has_many_example"

restapi = App::REST_API

RSpec.describe DCollection do
  include_examples "listers", DCollection
  include_examples "byid", DCollection
  include_examples "has_many", DCollection, "items"

end

