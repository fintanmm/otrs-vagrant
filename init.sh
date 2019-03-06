VERSION="6.0.16" # OTRS
# INSTALL_DIR="/data/www/otrs-$VERSION"

sudo mkdir -p /opt/otrs /data/www
# sudo ln -s /opt/otrs $INSTALL_DIR 
if rpm -q wget; then
    echo "do nothing"
else 
    yum --enablerepo=base clean metadata
    yum install -y wget
    yum install -y lsof
    yum install -y vim
    yum install -y epel-release

    yum install -y mod_perl
    yum -y install "perl(Text::CSV_XS)"
    yum install -y git-core
    yum install perl-App-cpanminus.noarch
    yum install -y "perl(Crypt::Eksblowfish::Bcrypt)"
    yum install  -y "perl(Crypt::SSLeay)"
    yum install -y "perl(DBD::Pg)"
    yum install -y "perl(Encode::HanExtra)"
    yum install -y "perl(IO::Socket::SSL)"
    yum install -y "perl(JSON::XS)"
    yum install -y "perl(Mail::IMAPClient)"
    yum install -y "perl(IO::Socket::SSL)"
    yum install -y "perl(Authen::SASL)"
    yum install -y "perl(JSON::XS)"
    yum install -y "perl(Mail::IMAPClient)"
    yum install -y "perl(Authen::NTLM)"
    yum install -y "perl(ModPerl::Util)"
    yum install -y "perl(Net::DNS)"
    yum install -y "perl(Net::LDAP)"
    yum install -y "perl(Template)"
    yum install -y "perl(Template::Stash::XS)"
    yum install -y "perl(XML::LibXML)"
    yum install -y "perl(XML::LibXSLT)"
    yum install -y "perl(XML::Parser)"
    yum install -y "perl(YAML::XS)"
    yum install -y "perl(Archive::Tar)"
    yum install -y "perl(Archive::Zip)"
    yum install -y "perl(Date::Format)"
    yum install -y "perl(DateTime)"
    yum install -y "perl(Net::DNS)"
    yum install -y "perl(Encode::HanExtra)"
    yum install -y "perl(YAML::XS)"
    yum install -y "perl(DBD::Pg)"
    yum -y install gcc make "perl(CPAN)"
    yum -y install "perl(Sys::Syslog)"
    yum -y install mod_ssl openssl
fi

echo "Download otrs..."
cd /tmp
if [ ! -f ./otrs-$VERSION.tar.bz2 ]; then
    wget –q "http://ftp.otrs.org/pub/otrs/otrs-$VERSION.tar.bz2" -O "./otrs-$VERSION.tar.bz2" #> /dev/null
    echo "extract otrs..."
    sudo tar xjf otrs-$VERSION.tar.bz2 --strip 1 -C /opt/otrs
fi

echo "Add otrs user..."
sudo useradd -d /opt/otrs -c 'OTRS user' otrs
sudo usermod -G apache otrs

echo "Copying OTRS Config.pm"
cd /opt/otrs
cp Kernel/Config.pm.dist Kernel/Config.pm
# cp Kernel/Config/GenericAgent.pm.dist Kernel/Config/GenericAgent.pm 
sudo chown -R otrs:apache /opt/otrs 



echo "Check perl dependencies"
sudo perl /opt/otrs/bin/otrs.CheckModules.pl
sudo perl -cw /opt/otrs/bin/cgi-bin/index.pl
sudo perl -cw /opt/otrs/bin/cgi-bin/customer.pl
sudo perl -cw /opt/otrs/bin/otrs.SetPermissions.pl
sudo /opt/otrs/bin/otrs.SetPermissions.pl  --otrs-user=otrs --web-group=apache

echo "HTTPD Config..."
sudo cp /opt/otrs/scripts/apache2-httpd.include.conf /etc/httpd/conf.d/otrs.conf
# sudo sed -i "s/opt\/otrs/data\/\www\/otrs-$VERSION/g" /etc/httpd/conf.d/otrs.conf
sudo systemctl enable httpd
sudo systemctl restart httpd

sudo mkdir -p /opt/otrs/module-tools
sudo cp /tmp/config.pl /opt/otrs/module-tools/config.pl

echo "Adding otrs to the Wheel group"
usermod -a -G wheel otrs
echo 'wheel ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

sudo systemctl status httpd.service

echo "Disabling SELinux"
setenforce 0
sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config
exit 0
