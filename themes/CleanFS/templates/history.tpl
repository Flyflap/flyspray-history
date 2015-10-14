<?php $gw=800; # chart width
?>
<p>
Start:<?php echo $start;?><br>
Heute:<?php echo $today[0];?>
</p>
<?php if($total>0): ?>
<svg style="position:relative;top:0px;z-index:-10" viewport="0 0 <?php echo $gw; ?> 800" height="800" width="<?php echo $gw; ?>" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg">
<defs>
    <linearGradient id="linear1" x1="0%" y1="0%" x2="50%" y2="0%">
      <stop offset="0%"   stop-color="#f66"/>
      <stop offset="100%" stop-color="#600"/>
    </linearGradient>
    <linearGradient id="linear2" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="40%" stop-color="#66f"/>
      <stop offset="80%" stop-color="#006"/>
      <stop offset="100%" stop-color="#006"/>
    </linearGradient>
    <linearGradient id="linear3" x1="0%" y1="0%" x2="50%" y2="0%">
      <stop offset="0%"   stop-color="#6f6"/>
      <stop offset="100%" stop-color="#060"/>
    </linearGradient>
    <linearGradient id="linear4" x1="0%" y1="0%" x2="50%" y2="0%">
      <stop offset="0%"   stop-color="#6f6"/>
      <stop offset="100%" stop-color="#9f9"/>
    </linearGradient>
    <linearGradient id="linear5" x1="0%" y1="0%" x2="50%" y2="0%">
      <stop offset="0%"   stop-color="#6f6"/>
      <stop offset="100%" stop-color="#060"/>
    </linearGradient>

<!-- stepped variants -->
	<linearGradient id="linear11" x1="90%"  xlink:href="#linear1" />
	<linearGradient id="linear12" x1="80%"  xlink:href="#linear1" />
	<linearGradient id="linear13" x1="50%" x2="100%" xlink:href="#linear1" />
	<linearGradient id="linear14" x1="0" x2="60%" xlink:href="#linear1" />
	<linearGradient id="linear15" x1="0" x2="30%" xlink:href="#linear1" />

	<linearGradient id="linear21" x1="40%" x2="60%" xlink:href="#linear2" />
	<linearGradient id="linear22" x1="80%" xlink:href="#linear2" />
	<linearGradient id="linear23" x1="0" xlink:href="#linear2" />
	<linearGradient id="linear24" x1="0" xlink:href="#linear2" />
	<linearGradient id="linear25" x1="0" xlink:href="#linear2" />

	<linearGradient id="linear31" x1="90%" xlink:href="#linear3" />
	<linearGradient id="linear32" x1="80%" xlink:href="#linear3" />
	<linearGradient id="linear33" x1="0" xlink:href="#linear3" />
	<linearGradient id="linear34" x1="0" xlink:href="#linear3" />
	<linearGradient id="linear35" x1="0" xlink:href="#linear3" />

	<linearGradient id="linear41" x1="90%" xlink:href="#linear4" />
	<linearGradient id="linear42" x1="80%" xlink:href="#linear4" />
	<linearGradient id="linear43" x1="0" xlink:href="#linear4" />
	<linearGradient id="linear44" x1="0" xlink:href="#linear4" />
	<linearGradient id="linear45" x1="0" xlink:href="#linear4" />

	<linearGradient id="linear51" x1="90%" x2="110%" xlink:href="#linear5" />
	<linearGradient id="linear52" x1="80%" x2="220%" xlink:href="#linear5" />
	<linearGradient id="linear53" x1="0" x2="240%" xlink:href="#linear5" />
	<linearGradient id="linear54" x1="0" x2="260%" xlink:href="#linear5" />
	<linearGradient id="linear55" x1="0" x2="280%" xlink:href="#linear5" />


</defs>
<?php
$h=$total;
$hi=400;
$hs=200/$total;
$hs2=1;
$l=array(); #lines
$max=($today[0]-$start);
$stack=array();
foreach ($tasks as $t):
	$stack[$t['date_closed']][]=$t['task_id'];
	$h=$total-(count($stack, COUNT_RECURSIVE)-count($stack));
	array_splice($stack, 1, $t['date_opened']);
	#$h--;

	$l[$t['task_id']]=array();
# PLEASE REVIEW
# dumb simple solution: just choose of 5 different stepped linear gradients for each tasktype.
# Because I don't know how to proportional apply gradient parts to a svg line like 0..30% for only bright part of a bright->to->dark gradient.
# And defining a gradient for every line seems too heavy. (resulting filesize. And browsers have no chance to speed up rendering by using cached gradients. Well, i do not know if they do..)
$subgradient='';
if($t['date_closed']==0){
	if($t['date_opened']){}
	elseif($t['date_opened']){}
	elseif($t['date_opened']){}
	elseif($t['date_opened']){}
}else{
	$percent=($t['date_closed']-$t['date_opened'])/$max;
	if($percent < 0.1){
		$subgradient=1;
	}elseif($percent < 0.2){
		$subgradient=2;
	}else{
		$subgradient='';
	}
# print_r($t['date_opened']);echo " ";
# print_r($t['date_closed']);echo " ";
# print_r($stack);
#die();
}
# NOTE 20151011: +0.1 to avoid a bug in Firefox when rendering exact horizontal or exact vertical svg lines. Claims to be fixed in 2003(!), but problem exists too in Firefox 41.0.1 (at least on Windows7 and Linux) 
?>
<g>
<path fill="none" stroke-width="<?php echo $hs; ?>" stroke="url(#linear<?php echo $t['task_type']; ?><?php echo $subgradient; ?>)" d="M<?php echo $gw*($t['date_opened']-$start)/$max; ?>,<?php echo $h*$hs;?>L<?php echo $t['date_closed']==0 ? $gw : $gw*($t['date_closed']-$start)/$max; ?>,<?php echo 0.1+$h*$hs;?>"/>
</g>
<?php endforeach; 
#print_r($stack);die();

?>
<?php
$t1p='';
$t2p='';
$t3p='';
$t4p='';
$t5p='';
echo count($pit);
#print_r($pit);
foreach ($pit as $p):
	$t1p.='L'.($gw*($p['time']-$start)/$max).','.($hi-$hs*$p['t1']);
	$t2p.='L'.($gw*($p['time']-$start)/$max).','.($hi-$hs*($p['t2']+$p['t1']) );
	$t3p.='L'.($gw*($p['time']-$start)/$max).','.($hi-$hs*($p['t3']+$p['t1']+$p['t2']) );
	$t4p.='L'.($gw*($p['time']-$start)/$max).','.($hi-$hs*($p['t4']+$p['t1']+$p['t2']+$p['t3']) );
	$t5p.='L'.($gw*($p['time']-$start)/$max).','.($hi-$hs*($p['t5']+$p['t1']+$p['t2']+$p['t3']+$p['t4']) );
endforeach;
?>
<g>
<path fill="#ff0" stroke-width="<?php echo $hs2; ?>" stroke="url(#linear5)" d="M0,<?php echo $hi.$t5p.'L'.$gw.','.($hi-$hs*($p['t5']+$p['t1']+$p['t2']+$p['t3']+$p['t4'])).'L'.$gw; ?>,400L0,400"/>
<path fill="#f9f" stroke-width="<?php echo $hs2; ?>" stroke="url(#linear4)" d="M0,<?php echo $hi.$t4p.'L'.$gw.','.($hi-$hs*($p['t4']+$p['t1']+$p['t2']+$p['t3'])).'L'.$gw; ?>,400L0,400"/>
<path fill="#cfc" stroke-width="<?php echo $hs2; ?>" stroke="url(#linear3)" d="M0,<?php echo $hi.$t3p.'L'.$gw.','.($hi-$hs*($p['t3']+$p['t1']+$p['t2'])).'L'.$gw; ?>,400L0,400"/>
<path fill="#ccf" stroke-width="<?php echo $hs2; ?>" stroke="url(#linear2)" d="M0,<?php echo $hi.$t2p.'L'.$gw.','.($hi-$hs*($p['t2']+$p['t1'])).'L'.$gw; ?>,400L0,400"/>
<path fill="#fcc" stroke-width="<?php echo $hs2; ?>" stroke="url(#linear1)" d="M0,<?php echo $hi.$t1p.'L'.$gw.','.($hi-$hs*$p['t1']).'L'.$gw; ?>,400L0,400"/>
</g>
</svg>
<?php else: ?>
<p>No tasks to view.</p>
<?php endif; ?>
