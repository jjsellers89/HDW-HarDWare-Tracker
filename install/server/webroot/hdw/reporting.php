<?php
# Future implentation: make this only available to authorized nodes
#
# Debug: print $_POST['NodeID'] . "\n" . $_POST['SelectorType'] . "\n" . $_POST['ObservedSelector'] . "\n" . $_POST['ObservedTime'] . "\n" . $_POST['ReportedTime'] . "\n" . $_POST['gps_lat'] . "\n" . $_POST['gps_lon'] . "\n";
#
$NodeID = $_POST['NodeID'];
$SelectorType = $_POST['SelectorType'];
$ObservedSelector = $_POST['ObservedSelector'];
$ObservedTime = $_POST['ObservedTime'];
#$ReportedTime = $_POST['ReportedTime']; # this is taken care of by the NOW() in SQL query
$gps_lat = $_POST['gps_lat'];
$gps_lon = $_POST['gps_lon'];
#
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	include "/var/www/db_creds/hdw.php";
	$query = "insert into report (NodeID, SelectorType, ObservedSelector, observedtime, reportedtime, gps_lat, gps_lon) values ($NodeID, '$SelectorType', '$ObservedSelector', '$ObservedTime', NOW(), '$gps_lat', '$gps_lon')";
	if (@mysqli_query($dbc, $query)) {
		print "Reported successfully";
	} else {
		print "Report failed\n" . mysqli_error($dbc) ."\n" ;
	}
	mysqli_close($dbc);
}
#
?>