<html>
<head>
  <script src="http://maps.google.com/maps/api/js?sensor=false"></script>
  <script src="http://media.scraperwiki.com/js/jquery-1.3.2.js"></script>
  <script src="http://media.scraperwiki.com/js/jquery-1.3.2.js"></script>
</head>
<body>

<h2>Australian Post Offices</h2>

<div id="mapdiv" style="width:100%;height:600px"></div>


<script>
var map;
var sourcescraper = 'australian_post_offices';
function makemap()
{
    var cpos = new google.maps.LatLng(-24.982074, 134.282225); 
    var mapOptions = { "zoom": 4, "center": cpos, "mapTypeId": google.maps.MapTypeId.HYBRID };
    map = new google.maps.Map(document.getElementById("mapdiv"), mapOptions);

    var apiurl = "http://api.scraperwiki.com/api/1.0/datastore/sqlite"; 
    var sqlselect = "select lat, long from swdata";
    var icon = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=X|0f0|f0f';
    $.ajax({url:apiurl, dataType: "jsonp", data:{name:sourcescraper, query:sqlselect, format:"jsonlist"}, success:function(tdata)
    { 
        var data = tdata.data; 
console.log(data); 
        for (var i = 0; i < data.length; i++)
            var marker = new google.maps.Marker({position:new google.maps.LatLng(data[i][0], data[i][1]), map:map});
    }});
}
$(window).ready(function() 
{
    $("h2 span").text(sourcescraper); 
    makemap(); 
});
</script>

</body>
</html>

