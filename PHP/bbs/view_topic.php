<?php
  /**************************************/
  /*		文件名：view_topic.php		*/
  /*		功能：文章详细页面			*/
  /**************************************/

  require('config.inc.php');

  //根据ID取得贴子记录
  $id=$_GET['id'];
  $sql="SELECT * FROM forum_topic WHERE id='$id'";
  $result=mysql_query($sql);
  $rows=mysql_fetch_array($result);

  //记录不存在
  if (!$rows) 
  {
	ExitMessage("该贴记录不存在！", "main_forum.php");
  }

  //置顶标记
  $sticky=$rows['sticky'];

?>

<?php include('header.inc.php'); ?>

<h2><? echo $rows['topic']; ?></h2>
<em class="info">
	由<a href="view_profile.php?id=<?php echo $rows['name']; ?>">
	<? echo $rows['name']; ?></a> 于 <? echo $rows['datetime']; ?>
	创建
</em>

<p>
<?php
	//输出整理好的内容
	echo nl2br(htmlspecialchars($rows['detail']));
?>
</p>
<?php if ($rows['locked']) { $locked = 1; } ?>
<hr size=1 />
<dl>
<?php

  //获取回复内容
  $sql	="SELECT * FROM forum_reply WHERE topic_id='$id'";
  $result	= mysql_query($sql);
  $num_rows = mysql_num_rows($result);

  if ($num_rows)
  {
	//循环取出记录内容
	while($rows=mysql_fetch_array($result))
	{
?>
 <dt>
    <a href="view_profile.php?id=<?php echo $rows['reply_name']; ?>">
    	<? echo $rows['reply_name']; ?>
    </a>
     - <em><?php echo $rows['reply_datetime']; ?></em>
 </dt>
 <dd>
  <p><?php
    	//输出整理好的内容
    	echo nl2br(htmlspecialchars($rows['reply_detail'])); 
     ?></p>
 </dd>
 <?
	}//结束循环
  }else{
	echo "<p><strong>没有跟贴记录。</strong></p>";
  }

  //浏览量加1
  $sql = "UPDATE forum_topic set view=view+1 WHERE id='$id'";
  $result = mysql_query($sql);

?>
</dl>

<!--内容回复表单，开始-->
<fieldset>
<legend>贴子回复</legend>
<?php 
//判断用户是否已经注册
if (!$_SESSION['username'])
{
	echo '<p>请先<a href="create_user.php">注册</a>，
		  或者<a href="logon_form.php">登录</a>或后进行操作。<br>&nbsp;</p>';
} else {

	//帖子已经被锁定
	if ($locked == 1)
	{ 
		echo '<p><strong>该贴是被锁定的，无法回帖</strong><br>&nbsp;</p>';
	}else{
?>
<form name="form1" method="post" action="add_reply.php" id="reply">
 <input name="id" type="hidden" value="<? echo $id; ?>">
 <table>
  <tr>
   <td valign="top">回帖<br>内容</td>
   <td>
    <textarea name="reply_detail" cols="45" rows="10"></textarea>
   </td>
  </tr>
  <tr>
   <td valign="top">&nbsp;</td>
   <td><em>请不要使用HTML标签</em></td>
  </tr>
 </table>
 <br />
 <input type="submit" name="Submit" value="回复该帖" class="button" />
 <input type="reset" name="Reset" class="button" />
</form>
<?php } ?>
</fieldset><br>
<!--内容回复表单，结束-->

<?php 
  //如果是管理员用户，则输出“置顶”、“锁定”和“删除”按钮
  if ($_SESSION['username'] == ADMIN_USER)
  { 
?>
<!--管理员操作表单，开始-->
<fieldset>
<legend>管理员操作</legend>

   <!--显示锁定操作按钮-->
   <?php if ($locked == 0) { ?>
	<form name="lock" method="post" action="lock_topic.php">
	 <input type="hidden" name="id" value="<?php echo $id; ?>">
	 <input type="submit" name="Submit" value="锁定该贴" class="button">
	 将该贴锁定，其他用户无法回复
	</form>
  <?php }else{ ?>
	<form name="unlock" method="post" action="unlock_topic.php">
	 <input type="hidden" name="id" value="<?php echo $id; ?>">
	 <input type="submit" name="Submit" value="解除锁定" class="button">
	 解除锁定，其他人可以回复
	</form>
  <?php } ?>

  <!--显示置顶操作按钮-->
  <?php if ($sticky == 0) { ?>
	<form name="stick" method="post" action="stick_topic.php">
	 <input type="hidden" name="id" value="<?php echo $id; ?>">
	 <input type="submit" name="Submit" value="置顶该贴" class="button">
	 将该贴置于顶端
	</form>
  <?php } else { ?>
	<form name="unstick" method="post" action="unstick_topic.php">
	 <input type="hidden" name="id" value="<?php echo $id; ?>">
	 <input type="submit" name="Submit" value="取消置顶" class="button">
	 取消该贴置顶
	</form>
  <?php } ?>
  
  <!--显示删除操作按钮-->
  <form name="delete" method="get" action="del_topic.php">
	 <input type="hidden" name="id" value="<?php echo $id; ?>">
	 <input type="submit" name="Submit" value="删除帖子" class="button">
	 删除该帖与回复内容
  </form>
</fieldset>
<!--管理员操作表单，结束-->
<?php 
	} 
}
?>

<?php include('footer.inc.php'); ?>
