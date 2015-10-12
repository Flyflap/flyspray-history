<?php
if (!defined('IN_FS')) {
	die('Do not access this file directly.');
}

if (!$user->can_view_project($proj->id)) {
	$proj = new Project(0);
}
?>
