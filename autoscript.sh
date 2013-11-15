yes | sudo yum install gcc
wget http://kaz.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.0/zabbix-2.2.0.tar.gz
tar -xvf zabbix*
cd zabbix-2.2.0
./configure --enable-agent
sudo make install
wget https://raw.github.com/anjani-phuyal/zabbix/master/zabbix_agentd.conf
sudo rm /usr/local/etc/zabbix_agentd.conf
sudo cp zabbix_agentd.conf /usr/local/etc/zabbix_agentd.conf
zabbix_agentd
