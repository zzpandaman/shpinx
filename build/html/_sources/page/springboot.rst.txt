Springboot
==========
what's springboot
 
hello
-----
IDE: eclipse maven 

Maven: `下载搭建环境 <https://www.cnblogs.com/pengyan-9826/p/7767070.html>`_ 

Way:  three ways.

	  * create in: `https://start.spring.io/ <https://start.spring.io/>`_  ,then import
	  * create in IDE: `some differences <https://blog.csdn.net/xujian_2001/article/details/78894833>`_
	  * create in Command(haven't try)
	  
Problem:

 * is not java source floder:
  这是由于maven项目不是eclipse认识的，到项目目录下执行 ``mvn eclipse:eclipse`` 会生成.classpath和.project文件,第一次回下载相关包到本地maven仓库。
  
Getting Start:

 * `入手项目 <https://spring.io/guides/gs/rest-service/>`_
  
 
JdbcTemplate
------------
Getting Start:

 * `入手项目 <https://spring.io/guides/gs/relational-data-access/>`_
 * 链接地址 ``http://localhost:8080/h2-console`` 可以看到h2数据库可视化界面（实操失败）