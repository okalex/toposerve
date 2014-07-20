var width = window.innerWidth,
    height = window.innerHeight;

var projection = d3.geo.mercator()
                    .scale((width + 1) / 2 / Math.PI)
                    .translate([width / 2, height / 2]);
var path = d3.geo.path().projection(projection);
var zoom = d3.behavior.zoom()
              .scaleExtent([1, 11])
              .on("zoom", zoomed);

var svg = d3.select('body').append('svg')
            .attr('width', width)
            .attr('height', height)
            .append('g');
var g = svg.append("g");

svg.call(zoom).call(zoom.event);

function zoomed() {
  g.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
}

function add_objects(objects, css_class) {
  g.append('path')
    .datum(objects)
    .attr('class', css_class)
    .attr('d', path);
}

function render_map(src) {
  d3.json(src, function(error, world) {

    if (error) return console.error(error);
    console.log('world', world);

    var land = topojson.feature(world, world.objects.land);
    console.log('land', land);
    add_objects(land, 'country');

    //var lakes = topojson.merge(world, world.objects.lakes.geometries);
    //console.log('lakes', lakes);
    //add_objects(lakes, 'lake');

    //var rivers = topojson.merge(world, world.objects.rivers.geometries);
    //add_objects(rivers, 'river');

    var boundaries = topojson.mesh(world, world.objects.land, function(a, b) { return a !== b; });
    console.log('boundaries', boundaries);
    add_objects(boundaries, 'boundary');

  });
}
