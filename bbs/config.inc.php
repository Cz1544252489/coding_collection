<?php
	/*******************/
	/*  系统参数设置   */
	/*******************/

	//连接数据库的定义
	define('DB_USER',		 "root");		//用户名
	define('DB_PASSWORD',	 "123456");		//密码
	define('DB_HOST',		 "localhost");	//数据库主机地址
	define('DB_NAME',		 "php_bbs");	//数据库

	//管理员用户
	define('ADMIN_USER',	"admin");

	//分页设置，每页最多显示的记录数
	define('EACH_PAGE',	 5);

	//无效的字符，用于ClearSpecialChars()函数
	$invalidchars = array(
		"'",				//单引号
		";",				//分号
		"=",				//等号
		"\\",				//反斜线
		"/"					//斜线
	);

	//“脏字”数组，用于FilterBadWords()
	$badwords=array
	(
		"fuck", "shit", "wanker", "cunt", "gay",
		"nigger", "bastard", "tosser", "dipshit",
		"homosexual", "nigga", "gaylord", "retard",
		"asshole", "slut", "prick", "cock", "pussy",
		"bitch", "wanking", "bollocks" 
	);

	/*******************/
	/*  公共函数设置   */
	/*******************/

	//功能：检查电子邮件地址格式是否正确
	//输入：电子邮件地址
	//输出：true或false
	function CheckEmail($email)
	{
		$check = "/^[0-9a-zA-Z_-]+@[0-9a-zA-Z_-]+(\.[0-9a-zA-Z_-]+){0,3}$/";
		
		if(preg_match ($check, $email)){
			return true;
		}
		else{
			return false;
		}
	}

	//功能：显示错误信息和返回的链接地址，并终止程序执行
	//输入：错误信息, 链接地址
	//输出：字符串
	function ExitMessage($message, $url='')
	{
		echo '<p class="message">';
		echo $message;
		echo '<br>';
		if($url){
	    	echo '<a href="'.$url.'">返回</a>';
	    }else{
	    	echo '<a href="#" onClick="window.history.go(-1);">返回</a>';
	    }
		echo '</p>';
		exit;
	}

	//功能：清除字符串中的特殊字符
	//输入：字符串
	//输出：字符串
	function ClearSpecialChars($str)
	{
		global $invalidchars;

		$str = trim($str);
		$str = str_replace($invalidchars,"",$str);
		return $str;
	}

	//功能：“脏字”处理程序
	//输入：字符串
	//输出：字符串
	function FilterBadWords($str)
	{
		global $badwords;

		//替代字数组
		$replacements=array("[ensored]", "***");

		for($i=0;$i < sizeof($badwords);$i++)
		{
			//随机函数发生器
			srand((double)microtime()*1000000); 
			
			//生成随机代码
			$rand_key = (rand()%sizeof($replacements));
			$str=eregi_replace($badwords[$i], $replacements[$rand_key], $str);
		}
		return $str;
	}

	/*******************/
	/*   初始化程序    */
	/*******************/

	//开启SESSION
	session_start();

	//打开数据库连接
	$db = mysql_pconnect(DB_HOST, DB_USER, DB_PASSWORD);
	if (!$db) 
	{
	   die('<b>数据库连接失败！</b>');
	   exit;
	}
	//选择数据库
	mysql_select_db (DB_NAME);

?>
