VERSION="6.0.6" # OTR
echo "Copying config file"
sudo mv Config.pm /opt/otrs/Kernel/Config.pm
sudo chown otrs:apache /opt/otrs/Kernel/Config.pm
sudo chmod 770 /opt/otrs/Kernel/Config.pm

echo "Installing database..."
cd /tmp
if [ ! -f ./pgdg-centos95-9.5-3.noarch.rpm ]; then
    wget https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm -O ./pgdg-centos95-9.5-3.noarch.rpm #> /dev/null
    sudo rpm -ivh pgdg-centos95-9.5-3.noarch.rpm
    sudo yum -y update
    sudo yum install -y postgresql95-server.x86_64
fi

if [ -z "$(ls -A /var/lib/pgsql/9.5/data)" ]; then
    su -c " /usr/pgsql-9.5/bin/initdb -D /var/lib/pgsql/9.5/data" -s /bin/bash postgres
fi
sudo systemctl start postgresql-9.5.service
sudo systemctl enable postgresql-9.5.service


su -c "createuser otrsqueries" -s /bin/bash postgres
su -c "dropdb otrs" -s /bin/bash postgres

# if [ ! -d /var/lib/pgsql/9.5/data ]; then
    su -c "createuser otrs" -s /bin/bash postgres
    su -c "echo \"alter user otrs with encrypted password 'otrs-ioa';\"| psql " -s /bin/bash postgres
    su -c "createdb otrs -O otrs" -s /bin/bash postgres
# fi
gunzip -d /tmp/otrs.sql.gz
su -c "psql -d otrs -f otrs.sql" -s /bin/bash postgres
