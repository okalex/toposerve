# TopoServe - Geospatial data server

Getting geo data from the internet can be kind of a pain. TopoServe aims
to ease that burden by providing a simple API for high-quality, 
publicly-available datasets, allowing for simple integration with tools
such as D3.js.

## Installation

You will need the following tools available on your server:

* [GDAL](http://www.gdal.org/)
* [TopoJson](https://github.com/mbostock/topojson)
* Ruby

Install necessary gems:

`bundle install`

Start the server:

`shotgun app.rb`

**Please note:** This app is far from complete.
