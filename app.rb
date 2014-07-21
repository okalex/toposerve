require 'sinatra'
require 'sinatra/param'
require 'yaml'
require 'tempfile'

helpers Sinatra::Param

country_codes = YAML.load_file('data/country_codes.yaml')

get '/' do
  erb :index, :locals => {:src => "/map?countries=#{params[:countries]}"}
end

get '/map' do
  param :countries, Array, default: []

  # This should be an alphabetized set
  requested_countries = params[:countries] || []
  if requested_countries.empty?
    filter = ''
  else
    requested_countries.map!(&:upcase).uniq!
    requested_countries.select! do |country|
      country_codes.has_key?(country)
    end
    requested_countries.sort!
    filter = "-where \"ADM0_A3 IN ('#{requested_countries.join("','")}')\""
  end

  cache_file = "/cache/world_#{requested_countries.join('_')}.json"
  unless File.exist?("public#{cache_file}")
    topofile = Dir::Tmpname.make_tmpname(['tmp/', '.json'], 'land')

    ogr_cmd = "ogr2ogr -f GeoJSON #{filter} #{topofile} data/countries.shp"
    puts ogr_cmd
    `#{ogr_cmd}`

    topojson_cmd = "topojson -o public#{cache_file} --id-property SU_A3 --properties name=NAME -- land=#{topofile}"
    puts topojson_cmd
    `#{topojson_cmd}`

    File.delete(topofile)
  end

  redirect(cache_file)
end
