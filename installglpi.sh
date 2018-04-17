# Executando
# bash installglpi.sh versao senha
# Exemplo
# bash installglpi.sh 9.2.2 12345


echo -e "deb  http://deb.debian.org/debian stretch main\ndeb-src http://deb.debian.org/debian stretch main\n\ndeb http://deb.debian.org/debian stretch-updates main\ndeb-src  http://deb.debian.org/debian stretch-updates main\n\ndeb http://security.debian.org/ stretch/updates main\ndeb-src http://security.debian.org/ stretch/updates main"  >  /etc/apt/sources.list  ; apt update -y ; apt upgrade -y


## Instalando Dependências

apt update ;
apt-get install curl unzip snmp apache2 php7.0 libapache2-mod-php7.0 php7.0-gd php7.0-ldap php7.0-curl php7.0-mbstring  -y ;
apt-get install sudo php7.0-bcmath php7.0-imap php-soap  php7.0-cli php7.0-common php7.0-snmp php7.0-xmlrpc  -y ;
apt-get install libmariadbd18 libmariadbd-dev mariadb-server php-dev php-pear php7.0-mysql php7.0-xml php-apcu-bc -y

## Baixando o GLPI
wget -c https://github.com/glpi-project/glpi/releases/download/$1/glpi-$1.tgz
tar  xfz glpi-$1.tgz -C /var/www/html/

## Definindo permissões
chown www-data:www-data -R /var/www/html/glpi
chmod 775 -R /var/www/html/glpi

## Criando arquivo de configuração para o apache
echo -e "<Directory \"/var/www/html/glpi\">\n\tAllowOverride All\n</Directory>" > /etc/apache2/conf-available/glpi.conf

## Criando virtualhost

echo -e "<VirtualHost *:80>\t
ServerAdmin admin@glpi\n\tServerName glpi\n\tServerAlias glpi\n\tDocumentRoot /var/www/html/glpi\n\tErrorLog ${APACHE_LOG_DIR}/error.log\n\tCustomLog ${APACHE_LOG_DIR}/access.log combined\n\n</VirtualHost>" > /etc/apache2/sites-available/glpi.conf

a2enconf glpi
a2ensite glpi.conf
systemctl  restart apache2

## Criando Banco de Dados GLPI
mysql -u root -e "create database glpi character set utf8";
mysql -u root -e "create user 'glpi'@'localhost' identified by '$2'";
mysql -u root -e "grant all on glpi.* to 'glpi'@'localhost'  with grant option";



