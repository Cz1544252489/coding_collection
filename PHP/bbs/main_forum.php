<?php
  /**************************************/
  /*		文件名：main_forum.php		*/
  /*		功能：论坛主页面			*/
  /**************************************/

  require('config.inc.php');

  //取得当前页数
  $page=$_GET['page'];

  //每页最多显示的记录数
  $each_page = EACH_PAGE;

  //计算页面开始位置
  if(!$page || $page == 1)
  {
	$start = 0;
  }else{
	$offset = $page - 1;
	$start = ($offset * $each_page);
  }
?>

<?php include('header.inc.php'); ?>

<h2>论坛</h2>
<p>

<?php
  //检索记录，按照置顶标记和时间排序
  $sql = "SELECT * FROM forum_topic 
	    ORDER BY sticky DESC, datetime DESC LIMIT $start, $each_page";
  $result = mysql_query($sql);
?>

<table width="100%" border="0" align="center" 
	cellpadding="3" cellspacing="1" bgcolor="#111">
<tr bgcolor="#E6E6E6">
<td width="60%" align="center"><strong>帖子</strong></td>
<td width="8%" align="center"><strong>访问量</strong></td>
<td width="8%" align="center"><strong>回复数</strong></td>
<td width="24%" align="center"><strong>日期</strong></td>
</tr>

<?php
  //循环输出输出记录列表
  while($rows=mysql_fetch_array($result))
  { 
?>
<tr bgcolor="#FFFFFF">
  <td>

<?php
	//如果是“置顶”的记录
	if ($rows['sticky'] == "1")
	{
	  ?><img src="sticky.gif" alt="置顶" border="0"><?php 
	}
  
	//如果是“锁定”的记录
	if ($rows['locked'] == "1")
	{
	  ?><img src="lock.gif" alt="锁定" border="0"><?php
	}
?>
	<a href="view_topic.php?id=<?php echo $rows['id']; ?>"><?php echo $rows['topic']; ?></a>
  </td>
  <td align="center">
	  <?php 
		echo $rows['view'];  //浏览量
	  ?>
  </td>
  <td align="center">
	  <?php 
		echo $rows['reply'];  //回复量
	  ?>
  </td>
  <td align="center">
	  <?php 
		echo $rows['datetime'];  //日期
	  ?>
  </td>
</tr>

<?php
  } //退出while循环
?>
<tr>
  <td colspan="5" align="right" bgcolor="#E6E6E6">
	<input type="button" onClick="location.href='create_topic.php'" value="创建新帖子">
  </td>
</tr>
</table>

<?php
  //计算前一页
  if($page > 1)
  {
	$prevpage = $page - 1;
  }

  //当前记录
  $currentend = $start + EACH_PAGE;

  //取得所有的记录数
  $sql = "SELECT COUNT(*) FROM forum_topic";
  $result = mysql_query($sql);
  $row = mysql_fetch_row($result);
  $total = $row[0];

  //计算后一页
  if($total>$currentend)
  {
	if(!$page){
		$nextpage = 2;
	}else{
		$nextpage = $page + 1;
	}
  }
?>

</p>

<p style="text-align: right;">

<?php

  //判断分页并输出
  if ($prevpage || $nextpage) 
  {
	//前一页
	if($prevpage)
	{
		echo "<a href=\"?page={$prevpage}\"><< 前一页</a> ";
	}else{
		echo "&nbsp";
	}

	//后一页
	if($nextpage)
	{
		echo "<a href=\"?page={$nextpage}\">后一页 >></a> ";
	}else{
		echo "&nbsp";
	}
  }
?>

</p>

<h3>标志</h3>
<p>
<img src="sticky.gif" alt="Sticky" border="0" align="absmiddle"> 置顶的帖子<br>
<img src="lock.gif" alt="Locked" border="0" align="absmiddle"> 锁定的帖子<br>

<?php 
	//检索在线用户
	$sql = "SELECT COUNT(*) FROM forum_user";
	$result = mysql_query($sql);
	$row = mysql_fetch_row($result);
	$total_user = $row[0];
?>

共有<b><?php echo $total_user ?></b>位注册的用户。</p>

<?php
  //公用尾部页面
  include('footer.inc.php') 
?>
