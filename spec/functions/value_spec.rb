require 'spec_helper'


describe 'namikoda::set_apikey' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params('aaaabbbb-cccc-dddd-eeee-ffffgggghhhh') }
end
describe 'namikoda::value' do
  it { is_expected.not_to eq(nil) }
  it { 

    stub_request(
      :get     ,  "https://api.namikoda.com/v1/public/ipsfor/dummy-success").
    with(
      :headers => { 'X-Namikoda-Key' => 'aaaabbbb-cccc-dddd-eeee-ffffgggghhhh' }).
    to_return(
      :status  => 200, 
      :body    => '{ "ipv4s":[ "1.2.3.4/32" ], "ipv6s":[ "1111:222:3000::/44" ], "lastUpdate":"2017-01-01T00:00:00.000Z", "name":"Dummy success value", "owner":"public", "id":"dummy-success", "value":[ "1.2.3.4/32", "1111:222:3000::/44" ] }',
      :headers => {})

    is_expected.to run.
    with_params('dummy-success').
    and_return( ["1.2.3.4/32", "1111:222:3000::/44"] ) 
  }
end

