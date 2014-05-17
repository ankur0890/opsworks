Date: 2013-10-16  
Title: HeBS OpsWorks Launch Script for CMS Enterprise
Published: true  
Type: post  
  

# HeBS OpsWorks Custom Chef Cookbook

Collection of scripts and configurations to set up and configure server(s) and CMS for HeBS application environment

### 1. Supported operating systems
---
1. Amazon Linux

Only Amazon Linux is currently supported; future updates may include Ubuntu LTS.


### 1.1. Installed packages
---

Server will be configured with nginx and php-fpm, and following extensions will be installed

* php
* php-fpm
* php-devel
* pcre-devel
* httpd-devel
* mysql
* php-mbstring
* php-exif
* php-xml
* php-common
* php-xmlrpc
* php-devel
* php-gd
* php-cli
* php-mysqli
* php-mcrypt
* php-mhash
* php-soap
* php-pecl-memcached
* php-pear
* php-pear-Auth-SASL
* php-pear-XML-Parser
* php-pear-Mail-Mime
* php-pear-DB
* php-pear-HTML-Common

## 2. Installation
### 2.1 Enable custom Chef cookbooks
You need to define **Repository URL** in Custom Chef Recipes, and also repository SSH key.

1. Log in to [OpsWorks](https://console.aws.amazon.com/)
2. Click on Stack, Edit
3. Make sure Chef version is newest, **11.4**
4. Use Custom Chef cookbooks is **On**
5. Repository URL: *git@bitbucket.org:hebsdigital-ondemand/opsworks-cms.git*
6. Repository SSH key: See [MyMessageSafe](https://www.mymessagesafe.com/message_view/6910/) for *hebs_deploy_privkey.txt*

Optionally, when setting up Staging environment, set following **custom JSON**

`{ "opsworks" : { "deploy_user": { "group": "nginx" } }, "server": { "env": "production", "swap": 1 }, "cms": { "mysql": { "username": "<rds_mysql_username>", "password": "<rds_mysql_password>", "database": "<rds_mysql_database_name>" }, "cache": { "prefix": "<cache_prefix>" } } }
`

### 2.2 Configure custom Chef recipes
Create *Layer* with short name *nginx* and type is *custom*

Configure following recipes:

1. Setup: **php-fpm**, **server::swap**
2. Configure: **php-fpm**, **cms::config**
3. Deploy: **deploy::nginx**
4. Undeploy: **deploy::nginx-undeploy**
5. Shutdown: **php-fpm::stop**

If server does not need swap, you can omit _server::swap_

Custom recipes will be executed right after built-in recipes are installed.

### 2.3 Configure CMS

Add new PHP app, set Git repository URL to *git@bitbucket.org:hebsdigital-ondemand/cms.git* and don't forget to provide Private Key from *hebs_deploy_privkey.txt* (see above)

Branch/Revision should be

* **releases/6.0** for Production

*Last updated: October 16, 2013 16:50 AM EST*