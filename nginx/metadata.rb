maintainer       "Aaron Abramson"
maintainer_email "amish@amishgeek.com"
license          "Apache 2.0"
description      "Installs/Configures nginx-php"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.1"

%w{ubuntu}.each do |os|
  supports os
end

depends "apt"
depends "php-fpm"