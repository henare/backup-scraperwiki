
<head>
 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
 <script src="http://media.scraperwiki.com/js/jquery-1.3.2.js"></script>
 
 <script type="text/javascript">
 google.load("visualization", "1", {packages:["corechart"]});
 google.setOnLoadCallback(function() 
 {
 var apiurl = "http://api.scraperwiki.com/api/1.0/datastore/sqlite"; 
 var srcname = "cttt-hearings"; 
 var sqlselect = "SELECT  temp.party_a, count(*) FROM (SELECT party_a FROM swdata UNION ALL  SELECT party_b FROM swdata) as temp GROUP BY party_a ORDER BY count(*)  desc LIMIT 50 COLLATE NOCASE";
 $.ajax({url:apiurl, data:{name:srcname, query:sqlselect, format:"jsonlist"}, dataType:"jsonp", success:function(tdata)
 {
     var data = new google.visualization.DataTable();
     data.addColumn('string', 'Name');
     data.addColumn('number', 'Appearances');
     data.addRows(tdata.data.length);
     for (var i = 0; i < tdata.data.length; i++)
     {
         data.setValue(i, 0, tdata.data[i][0]);
         data.setValue(i, 1, tdata.data[i][1]);
     }
     var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
     chart.draw(data, {width: 1200, height: 1800, legend: 'none', chartArea: {width: 200},
                      hAxis: {title: 'Appearances'},
                       vAxis: {title: 'Name', titleTextStyle: {color: 'red', "font-size":"50%"}}
                      });
 }}); 
 }); 
 
 
 </script>
 </head>
 
 <body>
 <div id="chart_div"></div>
 </body>
 