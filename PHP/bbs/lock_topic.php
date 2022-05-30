<?php
  /**************************************/
  /*		文件名：lock_topic.php		*/
  /*		功能：设置“锁定”操作		*/
  /**************************************/

  require('config.inc.php');

  //判断是否为管理员
  if ($_SESSION['username'] == ADMIN_USER)
  {
	//取得文章ID
	$id=$_POST['id'];

	//锁定的SQL语句
	$sql = "UPDATE forum_topic SET locked='1' WHERE id='$id'";

	$result=mysql_query($sql);

	if($result)
	{
		//跳转页面
		header("Location: view_topic.php?id=$id");
	}
	else {
		ExitMessage("数据库操作错误！");
	}
  } else {
	ExitMessage("你没有管理权限！");
  }
?>
