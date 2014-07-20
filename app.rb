require 'sinatra'
require 'sinatra/param'

helpers Sinatra::Param

get '/' do
  erb :index, :locals => {:src => "/map?countries=#{params[:countries]}"}
end

get '/map' do
  param :countries,  Array, default: []

  # This should be an alphabetized set
  countries = params[:countries] || []
  if countries.empty?
    filter = ''
  else
    filter = "-where \"ADM0_A3 IN ('#{countries.join("','")}')\""
  end

  cache_file = "/cache/world_#{countries.join('_')}.json"
  unless File.exist?("public#{cache_file}")
    `rm tmp/land.json`
    ogr_cmd = "ogr2ogr -f GeoJSON #{filter} tmp/land.json data/countries.shp"
    `#{ogr_cmd}`

    topojson_cmd = "topojson -o public#{cache_file} --id-property SU_A3 --properties name=NAME -- tmp/land.json"
    `#{topojson_cmd}`
  end

  redirect(cache_file)
end
