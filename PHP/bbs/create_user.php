<?php
  /**************************************/
  /*		文件名：create_user.php		*/
  /*		功能：生成用户注册页面		*/
  /**************************************/

  require('config.inc.php');
  include('header.inc.php');
?>

<h2>注册新用户</h2>

<fieldset>
<form method="post" action="add_user.php">
<table>
  <tr>
	<td>用户名:</td>
	<td><input name="username" type="text"></td>
  </tr>
  <tr>
    <td>密 码:</td>
    <td><input name="password" type="password"></td>
  </tr>
  <tr>
    <td>E-mail:</td>
    <td><input name="email" type="text"></td>
  </tr>
  <tr>
    <td>真实姓名:</td>
    <td><input name="realname" type="text"></td>
  </tr>
</table>

<input type="submit" name="Submit" value="提交注册" class="button"/>
<input type="reset" name="Submit2" value="清空" class="button"/>
</form>
</fieldset>

<?php 

	//公用尾部页面
	include('footer.inc.php');
?>
