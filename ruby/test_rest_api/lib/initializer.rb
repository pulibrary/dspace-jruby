require "dspace_rest"

module App
    BASE_URL  = "http://localhost:8080/rest"
    REST_API = DSpaceRest.new(BASE_URL)
end
