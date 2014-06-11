maintainer				"HeBS Digital"
maintainer_email		"support@hebsdigital.com"
license					"Copyright HeBS Digital. All Rights Reserved"
version					"6.0.1"
description				"Set of OpsWorks scripts to handle CMS installation"

depends 'nginx'
depends 'php-fpm'

recipe 'clear_cache', 'Clears CMS cache and restarts php-fpm'
recipe 'update_theme', 'Updates theme(s) assigned to CMS configuration'