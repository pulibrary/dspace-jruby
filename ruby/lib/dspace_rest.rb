require 'rest-client'
require 'json'

class DSpaceRest

  def initialize(baseurl)
    @baseurl = baseurl
    @last_res = nil;
    @login_token = nil;
  end

  def login(email, pwd)
  # curl -H "Accept: application/json" -H "Content-Type: application/json" \
#    -X POST  \
#    -d '{ "email" : "admin@admin.edu", "password" : "admin" }' \
#    http://localhost:8080/rest/login

    res = post("/login", {'email' => email, 'password' => pwd})
    raise "can''t login to #{@baseurl}" if  not res.is_a?(Net::HTTPSuccess)
    # @login_token = res.body;
  end

  def list(type, params)
    return get("/" + type, params)
  end

  def last_res
    return @last_rest
  end

  private
  def get(path, params)
    #TODO send login token along
    uri = @baseurl + path;
    res = RestClient.get uri, { "params" => params, "accept" => :json}
    @last_res = JSON.parse(res)
    return @last_res
  end

  def post(path, params)
    uri = @baseurl + path;
    @last_res = RestClient.post  uri, params.to_json, :content_type => :json, :accept => :json
    @last_res = JSON.parse(res)
    return @last_res
  end

end

