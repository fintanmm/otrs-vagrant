VERSION="6.0.16" # OTRS

cd /tmp
wget –q "http://ftp.otrs.org/pub/otrs/otrs-$VERSION.tar.bz2" -O "./otrs-$VERSION.tar.bz2" #> /dev/null
echo "extract otrs..."
sudo tar xjf otrs-$VERSION.tar.bz2 --strip 1 -C /opt/otrs
# INSTALL_DIR="/data/www/otrs-$VERSION"
echo "installing requirements for make"
yum install -y lndir
yum install -y perl-App-cpanminus.noarch
yum install -y xmlrpc-c.i686

echo "cloning module tools"
cd /opt
sudo git clone https://github.com/OTRS/module-tools
cd module-tools
sudo cpanm --installdeps .
cp  ./etc/config.pl.dist ./etc/config.pl
cd /home/vagrant
sudo cp config.pl /opt/module-tools/etc

# su -c "$INSTALL_DIR/bin/otrs.Daemon.pl start" -s /bin/bash otrs
su -c "/opt/otrs/bin/otrs.Daemon.pl start" -s /bin/bash otrs
su -c "wget http://ftp.otrs.org/pub/otrs/itsm/packages6/GeneralCatalog-$VERSION.opm -O /tmp/GeneralCatalog-$VERSION.opm" -s /bin/bash otrs
su -c "wget http://ftp.otrs.org/pub/otrs/itsm/packages6/ITSMCore-$VERSION.opm -O /tmp/ITSMCore-$VERSION.opm" -s /bin/bash otrs
su -c "wget http://ftp.otrs.org/pub/otrs/itsm/packages6/ITSMChangeManagement-$VERSION.opm -O /tmp/ITSMChangeManagement-$VERSION.opm" -s /bin/bash otrs
su -c "/opt/otrs/bin/otrs.Console.pl Admin::Package::Install /tmp/GeneralCatalog-$VERSION.opm" -s /bin/bash otrs
su -c "/opt/otrs/bin/otrs.Console.pl Admin::Package::Install /tmp/ITSMCore-$VERSION.opm" -s /bin/bash otrs
su -c "/opt/otrs/bin/otrs.Console.pl Admin::Package::Install /tmp/ITSMChangeManagement-$VERSION.opm" -s /bin/bash otrs


# echo "go to: http://localhost:3002/otrs/installer.pl"
echo "go to: http://localhost:3002/otrs/index.pl"
echo "Install Settings -> usr: root password: otrs-ioa"
echo "Vagrant VM credentials -> usr: vagrant password: vagrant"
