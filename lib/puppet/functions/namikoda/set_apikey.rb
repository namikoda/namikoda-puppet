Puppet::Functions.create_function(:'namikoda::set_apikey') do
  def set_apikey(passed_apikey)
    @@namikoda_apikey = passed_apikey
  end
end
