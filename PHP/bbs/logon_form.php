<?php
  /**************************************/
  /*		文件名：logon_form.php		*/
  /*		功能：用户登录程序			*/
  /**************************************/

  require('config.inc.php');

  if($_POST['submit'])
  {
	//用户名
	$username=ClearSpecialChars($_POST['username']);
	//密码，需要进行MD5加密
	$password=md5($_POST['password']);

	//从数据库中检索用户名，密码是否匹配
	$sql = "SELECT * FROM forum_user
		  WHERE username='$username' AND password='$password'";
	$result = mysql_query($sql);
	$num_rows = mysql_num_rows($result);
	
	if($num_rows == 1)
	{
		//获得用户名
		$row = mysql_fetch_assoc($result);

		//将用户名存如SESSION中
		$_SESSION['username'] = $row['username'];

		//跳转到论坛主页面
		header("Location: main_forum.php");
	}
	else {
		ExitMessage("用户名或者密码错误！", "logon_form.php");
	}
  }
  else{
	
	//公用头部页面
	include('header.inc.php');
?>

<h2>用户登录</h2>

<fieldset>
<form method="post" action="logon_form.php">
<table>
  <tr>
	<td>用户名：</td>
    <td><input name="username" type="text"></td>
  </tr>
  <tr>
    <td>密　码：</td>
	<td><input name="password" type="password"></td>
  </tr>
</table>
<input type="submit" name="submit" value="登录" class="button">
</form>
</fieldset>

<?php 
  }

  //公用尾部页面
  include('footer.inc.php'); 
?>
