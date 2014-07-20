require 'sinatra'
require 'sinatra/param'

helpers Sinatra::Param

get '/' do
  erb :index, :locals => {:src => "/map?countries=#{params[:countries]}"}
end

get '/map' do
  param :countries,  Array, default: []

  countries = params[:countries] || []
  if countries.empty?
    filter = ''
  else
    filter = "-where \"ADM0_A3 IN ('#{countries.join("','")}')\""
  end

  cache_file = "public/cache/world_#{countries.join('_')}.json"
  unless File.exist?(cache_file)
    `rm tmp/land.json`
    ogr_cmd = "ogr2ogr -f GeoJSON #{filter} tmp/land.json data/src/countries.shp"
    `#{ogr_cmd}`

    topojson_cmd = "topojson -o #{cache_file} --id-property SU_A3 --properties name=NAME -- tmp/land.json"
    `#{topojson_cmd}`
  end

  `cat #{cache_file}`
end
