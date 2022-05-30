<?php
  /******************************************/
  /*		文件名：edit_profile.php		*/
  /*		功能：用户资料修改页面		    */
  /******************************************/

  require('config.inc.php');

  //用户名
  $id = $_SESSION['username'];

  //如果用户没有登录
  if (!$_SESSION['username']) {
	ExitMessage("请<b>登录</b>后执行该请求。", "logon_form.php");
  }
?>

<?php include('header.inc.php'); ?>

<h2>编辑个人资料</h2>

<?php
  //查询用户资料
  $sql="SELECT * FROM forum_user WHERE username = '$id'";
  $result=mysql_query($sql);
  $rows=mysql_fetch_array($result);
?>
<fieldset>
	<legend>个人资料</legend>
<form method="post" action="update_profile.php">

<table>
  <tr>
    <td>登录用户：</td>
    <td><b><? echo $rows['username']; ?></b></td>
  </tr>
  <tr>
	<td>更新密码:</td><td><input name="password" type="password">
	密码留空，将不被更新。</td>
  </tr>
  <tr>
	<td>电子邮件:</td>
	<td><input name="email" type="text"
			value="<?php echo $rows['email']; ?>"></td>
  </tr>
  <tr>
	<td>真实姓名:</td>
	<td><input name="realname" type="text"
			 value="<?php echo $rows['realname']; ?>"></td>
  </tr>
</table>
<br><br>
<input type="submit" name="submit" value="更新个人资料" class="button"> 
</form>
</fieldset>
	
<?php include('footer.inc.php'); ?>
