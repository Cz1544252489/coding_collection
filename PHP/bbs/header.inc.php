<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=gb2312">
<title>淘到我心论坛</title>
<style type="text/css" media="all">
body { margin:0px; padding:0px; font:12px verdana, arial, helvetica, sans-serif;}
td, legend{ font-size:14px; line-height:16px;}
p { font-size:12px;}

/* HTML头样式 */
#Header { margin:10px 0px 10px 0px; padding:10px 8px 8px 20px; border-style:solid; 
	border-color:black; background-color:#eee; font-size:14px; height:14px;
}

/* HTML正文内容样式 */
#Content { margin:5px; width:100%; padding:10px;}
</style>
</head>

<body>
<h1>淘到我心论坛</h1>

<!-- 头开始 -->
<div id="Header">
<?php 
  //判断用户是否登录，从而显示不同的导航界面
  if($_SESSION['username']) 
  { 
?>
	<!-- 用户登录后的导航条 -->
	<strong><?php echo $_SESSION['username']; ?>，欢迎登录</strong> | &nbsp;
	<a href="main_forum.php">首页</a> | &nbsp;
	<a href="edit_profile.php">个人资料</a> | &nbsp;
	<a href="logoff_user.php">退出论坛</a>

<?php } else { ?>

	<!-- 用户未登录的导航条 -->
	<a href="main_forum.php">首页</a> | &nbsp;
	<a href="create_user.php">注册</a> | &nbsp;
	<a href="logon_form.php">登录</a>
<?php 
  }//判断结束
?>
	<br>
</div>
<!-- 头结束 -->

<!-- 正文内容开始 -->
<div id="Content">
