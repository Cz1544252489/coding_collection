<?php
  /***********************************/
  /*      文件名：create_topic.php   */
  /*      功能：发表文章页面		 */
  /***********************************/

  require('config.inc.php');
  include('header.inc.php'); 
?>

<h2>创建新贴</h2>

<?php 
  if (!$_SESSION['username'])
  { 
	  //如果用户未登录，显示错误信息
?>

<h3>未注册的用户</h3>
<p>对不起，请<a href="create_user.php">注册</a>新用户，
	或者进行<a href="logon_form.php">登录</a>。
</p>

<?php
  }else{ 
	//如果用户登录，显示输入表单
?>

<h3>发言注意事项</h3>
<ul>
	<li>所有项目必须填写。</li>
	<li>在标题和正文中不能使用HTML代码。</li>
	<li>为了安全起见，请不要在论坛中透录密码等重要信息。</li>
</ul>

<form method="post" action="add_topic.php" id="postComment">
<table>
  <tr>
	<td>话题</td>
	<td><input name="topic" type="text" id="topic" size="50"><td>
  </tr>
  <tr>
    <td>正文</td>
    <td><textarea name="detail" cols="50" rows="10" id="detail"></textarea></td>
  </tr>
</table>

<?php
  //如果是管理员，将显示“置顶”和“锁定”功能
  if ($_SESSION['username'] == ADMIN_USER)
  {
?>
	<br>将帖子置顶 <input type="checkbox" name="sticky" value="on">
	<br>锁定该帖子 <input type="checkbox" name="locked" value="on">
<?php
  }
?>

<br><br>
<input type="submit" name="Submit" value="立即发布" class="button">
<input type="reset" name="Submit2" class="button">
</form>

<?php } ?>

<?php 
	//公用尾部页面
	include('footer.inc.php'); 
?>
