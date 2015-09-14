require 'rest-client'
require 'json'

class DSpaceRest

  def initialize(baseurl)
    @baseurl = baseurl
    @last_res = nil;
    @login_token = nil;
  end

  def login(email, pwd)
    uri = @baseurl + "/login"
    params =  {'email' => email, 'password' => pwd}
    @login_token = RestClient.post  uri, params.to_json, :content_type => :json, :accept => :json
    return @login_token
  end

  def logout
    @login_token = nil;
  end

  def get(path, params)
    #TODO send login token along
    options = { "params" => params, :content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    uri = @baseurl + "/" + path
    res = RestClient.get uri, options
    @last_res = JSON.parse(res)
    return @last_res
  end

  def post(path, params)
    uri = @baseurl + "/" + path;
    puts uri;
    options = { :content_type => :json, :accept => :json}
    options['rest-dspace-token'] = @login_token if (not @login_token.nil?)
    @last_res = RestClient.post  uri, params.to_json, options
    @last_res = JSON.parse(@last_res)
    return @last_res
  end

end
