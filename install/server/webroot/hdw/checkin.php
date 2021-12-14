<?php
include "/var/www/db_creds/hdw.php";
$query = "SELECT * FROM config where nodeid=$_GET[NodeID]";
if ($r = mysqli_query($dbc, $query)) {
    while ($row = mysqli_fetch_array($r)) {
        print "NodeID={$row['NodeId']}
CollectInterval={$row['CollectInterval']}
ReportInterval={$row['ReportInterval']}
CheckinInterval={$row['CheckinInterval']}
WifiSTA_Active={$row['WifiSTA_Active']}
WifiAP_Active={$row['WifiAP_Active']}
BT_Active={$row['BT_Active']}
heartbeat_URL={$row['heartbeat_URL']}
checkin_URL={$row['checkin_URL']}
report_URL={$row['report_URL']}
";
    }
}
mysqli_close($dbc);
?>