require 'http';
require 'yaml';

class SolrQuery
  def initialize(options)
    @solrCoreBase = options['solrServer'] ||  options['solrStatiticsServer']  ; 
    raise "must give  solrServer/solrStatisticsServer" if not @solrCoreBase

    @query = options['query'] || { 'isBot' => true } 

    params = options['params'] || { } 
    @params = { "wt" => "json", "indent" => "true", "rows" => 0}.merge(params)

    @verbose = options['verbose']
    if (@verbose) then
      $stdout.puts self.to_yaml
    end
  end

  def verbose?
    return @verbose
  end

  def get()
    stats = getStatsFor( @params, @query ) 
    naccess = stats["response"]["numFound"]
    $stdout.puts "#NUMFOUND #{@query.inspect}\t#{naccess}\n";
    if (@verbose) then 
       $stdout.puts  JSON.pretty_generate(stats)
    end 
  end

  private

  def getStatsFor( params, qprops ) 
    qselect  = URI(@solrCoreBase + "/select");  
    params['q'] = (qprops.map{ |k,v| "#{k}:#{v}" }).join('+')
    qparams = params.map{|k,v| "#{k}=#{v}"} 
    qparams = qparams.join("&"); 
    if (@verbose) then
      $stdout.puts "#DEBUG #{qparams}"
    end
    qselect.query = URI.encode(qparams); 
    $stdout.puts "#DEBUG #{qselect}"
    return getJsonStats(qselect);
  end

  def getJsonStats(uri)
    begin
      res = HTTP.get(uri)
      stats = JSON.parse(res)
      return stats;
    rescue Exception => e
      puts "data error #{uri}:  #{e.message}"
      return {};
    end
  end 

end 

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: statistics.rb [options]  filename"

  opts.on("-y", "--yml options", "yml options file") do |v|
    options[:yml_options] = v
  end

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

init_file = options[:yml_options] || "community_statistics.yml";
puts "using #{init_file}"
options = YAML.load_file(init_file);

solr_query = SolrQuery.new(options);
solr_query.get(); 


