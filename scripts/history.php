<?php
/* experimental: charts for Flyspray */
if (!defined('IN_FS')) {
	die('Do not access this file directly.');
}

if (!$user->perms('view_reports')) {
	Flyspray::show_error(28);
}

if (!$user->can_view_project($proj->id)) {
	$proj = new Project(0);
}

$today=$db->query('SELECT UNIX_TIMESTAMP();');
$today=$db->FetchRow($today);

if($proj->id > 0){
	$result=$db->Query('SELECT task_id, date_opened, date_closed, item_status,project_id,task_type, (ROUND(date_opened DIV 86400)*86400) AS daystep
	FROM {tasks}
	WHERE project_id=?
	ORDER BY daystep ASC, task_type, date_closed ASC
	', $proj->id);

	$events=$db->Query('
SELECT task_id, date_opened AS "event", 0 AS "etype", item_status,project_id,task_type FROM {tasks}
WHERE project_id=?
UNION
SELECT task_id, date_closed AS "event", 1 AS "etype", item_status,project_id,task_type FROM {tasks}
WHERE project_id=? AND date_closed<>0

ORDER BY event ASC, etype ASC
	',
	array($proj->id,$proj->id)
	);
} else{
	$result=$db->Query('SELECT task_id, date_opened, date_closed, item_status,project_id,task_type, (ROUND(date_opened DIV 84600)*86400) AS daystep
	FROM {tasks}
	ORDER BY daystep ASC, task_type, date_closed ASC');

	$events=$db->Query('
SELECT task_id, date_opened AS "event", 0 AS "etype", item_status,project_id,task_type FROM {tasks}
UNION
SELECT task_id, date_closed AS "event", 1 AS "etype", item_status,project_id,task_type FROM {tasks}
WHERE date_closed<>0

ORDER BY event ASC, etype ASC');
}

$tasks=array();
$stack=array();
while ($t = $db->FetchRow($result)) {
        $tasks[]=$t;
	$stack[]=array($t['task_type']);
}

$pit[]=array('time'=>0,'t1'=>0,'t2'=>0,'t3'=>0,'t4'=>0,'t5'=>0);
$lastevent=array();
$ec=0;
while ($e = $db->FetchRow($events)) {
	$ev[]=$e;
	if ($ec>0 && $e["event"]!=$lastevent){
		# kopieren
		$pit[]=$pit[count($pit)-1];
		$pit[count($pit)-1]['time']=$e['event'];
	} elseif($ec==0){
		$pit[0]['time']=$e['event'];
	}
	$ec++;
	if ($e["etype"]==0){
		$pit[count($pit)-1]['t'.$e['task_type']]+=1;
	} elseif($e["etype"]==1 && $e["event"]!=0){
		# closed
		$pit[count($pit)-1]['t'.$e['task_type']]-=1;
	}

	$lastevent=$e['event'];
}

$total=count($tasks);

if ($total>0){
	$start=$tasks[0]['date_opened'];
}else{
	$start=0;
}
#echo '<pre>';print_r($tasks[2]);die();
#echo '<pre>';print_r($pit);die();
#print_r($tasks);die();
$page->uses('tasks','total', 'start','today', 'ev', 'pit');
$page->pushTpl('history.tpl');

?>
