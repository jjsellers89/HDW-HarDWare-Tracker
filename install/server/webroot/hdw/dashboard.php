<?php
define ('title', 'HDW Dashboard');
include 'templates/header.html';
?>
				<!-- This is the side navigation bar for nodes -->
<nav>
<ul>
<b>Nodes:</b>
<?php
include "/var/www/db_creds/hdw.php";
#print mysqli_connect_error(); # debug mysql errors
$query = "select distinct NodeID from report";
if ($r = mysqli_query($dbc, $query)) {
	while ($row = mysqli_fetch_array($r)) {
		print "
		<li>
		<a href=dashboard.php?NodeID=${row['NodeID']}>" 
		. $row['NodeID'] . 
		"</a>
		</li>";
	}
} else {
	print mysqli_error($dbc);
}
mysqli_close($dbc);
?>
<li>
<br><br>
</li>
<li>
<a href=dashboard.php><u>Clear view</u></a>
</li>
<li>
<a href=#><u>Reports</u></a>
</li>
</ul>
</nav>
				<!-- This section begins dashboard results -->
<body>
<div style="margin-left:10%; padding:1px 16px; height:40%; overflow:auto; border: 3px solid white; background-color: #595959;">
<table width=100%>
<tr>
<th>EventID</th>
<th>Type</th>
<th>Selector</th>
<th>Time (Observed)</th>
<th>Time (Reported)</th>
<th>Node</th>
<th>GPS Lat</th>
<th>GPS Lon</th>
</tr>
<?php
if (isset($_GET['NodeID'])) {
	include "/var/www/db_creds/hdw.php";
	$NodeID = $_GET['NodeID'];
	print mysqli_connect_error(); # debug mysql errors
	$query = "select * from report where NodeID=" . $NodeID . " order by reportid DESC limit 100";
	if ($r = mysqli_query($dbc, $query)) {
        	while ($row = mysqli_fetch_array($r)) {
			print "
			<tr>
				<td>{$row['reportid']}</td>
				<td>{$row['SelectorType']}</td>
				<td>{$row['ObservedSelector']}</td>
				<td>{$row['observedtime']}</td>
				<td>{$row['reportedtime']}</td>
				<td>{$row['NodeID']}</td>
				<td>{$row['gps_lat']}</td>
				<td>{$row['gps_lon']}</td>
            </tr>";
        	}
	} else {
        	print mysqli_error($dbc);
	}
	mysqli_close($dbc);
}
?>
</table>
</div>
<div style="margin-left:10%; padding:15px; overflow:auto; font-size: 14px;">
				<!-- This section is for node configuration -->
<?php 
/* This section will process configuration*/
if ((isset($_POST['NodeID'])) && (isset($_POST['CollectInterval'])) && (isset($_POST['ReportInterval'])) && (isset($_POST['CheckinInterval']))) {
	if (isset($_POST[WifiSTA_Active])) {
		$WifiSTA_Active=1;
	} else {
		$WifiSTA_Active=0;
	}
	if (isset($_POST[WifiAP_Active])) {
		$WifiAP_Active=1;
	} else {
		$WifiAP_Active=0;
	}
	if (isset($_POST[BT_Active])) {
		$BT_Active=1;
	} else {
		$BT_Active=0;
	} 
	include "/var/www/db_creds/hdw.php";
	$checkinURL = $_POST[checkin_URL]."?NodeID=".$_POST[NodeID];
	$query = "UPDATE config SET CollectInterval='$_POST[CollectInterval]',ReportInterval='$_POST[ReportInterval]',CheckinInterval='$_POST[CheckinInterval]',WifiSTA_Active='$WifiSTA_Active',WifiAP_Active='$WifiAP_Active',BT_Active='$BT_Active',heartbeat_URL='$_POST[heartbeat_URL]',checkin_URL='$checkinURL',report_URL='$_POST[report_URL]' WHERE NodeId={$_POST[NodeID]}";
        $r = mysqli_query($dbc, $query);
        if (mysqli_affected_rows($dbc) == 1) {
            print '<center style="color:lightgreen;"><b>The node configuration has been updated.</center></b><br>';
            } else {
				print mysqli_error($dbc);
			}
			mysqli_close($dbc);
}
/* This section is used for input */
if (isset($_GET['NodeID'])) {
	include "/var/www/db_creds/hdw.php";
	$query = "select * from config where NodeID=" . $NodeID;
	if ($r = mysqli_query($dbc, $query)) {
		while ($row = mysqli_fetch_array($r)) {
		print ' 
		<center>
		<form action="dashboard.php?NodeID='.$NodeID.'" method="POST">
		<b><u>Node '.$NodeID.'</b></u><p>
		<input type=hidden name=NodeID value="' . $_GET[NodeID] . '">
		Collection Interval (in seconds): <input type=text name=CollectInterval size=4 pattern="[0-9]{0,3}" value='.$row[CollectInterval].'><br>
		Report Interval (in seconds): <input type=text name=ReportInterval size=4 pattern="[0-9]{0,3}" value='.$row[ReportInterval].'><br>
		Checkin Interval (in seconds): <input type=text name=CheckinInterval size=4 pattern="[0-9]{0,3}" value='.$row[CheckinInterval].'><br>
		';
		if ($row[WifiSTA_Active] == "1") {
			print '<input type=checkbox name=WifiSTA_Active value=1 checked>';
		} else {
			print '<input type=checkbox name=WifiSTA_Active value=1>';
		}
		print '
		<label for=WifiSTA_Active>Collect Wifi Stations</label><br>';
		if ($row[WifiAP_Active] == "1") {
			print '<input type=checkbox name=WifiAP_Active value=1 checked>';
		} else {
			print '<input type=checkbox name=WifiAP_Active value=1>';
		}
		print '<label for=WifiAP_Active>Collect Wifi Access Points</label><br>';
		if ($row[BT_Active] == "1") {
			print '<input type=checkbox name=BT_Active value=1 checked>';
		} else {
			print '<input type=checkbox name=BT_Active value=1>';
		}
		print '<label for=BT_Active>Collect Bluetooth Devices</label><br>

		Heartbeat URL: <input type=text name=heartbeat_URL size=35 maxsize=100 value='.$row[heartbeat_URL].'><br>
		Checkin URL: <input type=text name=checkin_URL size=35 maxsize=100 value='.strstr($row[checkin_URL],'?',true).'><br>
		Report URL: <input type=text name=report_URL size=35 maxsize=100 value='.$row[report_URL].'><br>

		<input type=submit name=submit value="Update configuration">
		</center>';
		}
	}	else {
        	print mysqli_error($dbc);
		}
	mysqli_close($dbc);
}
?>
</div>
</body>
</html>