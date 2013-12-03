#after the zabbix init file is in /etc/init.d with name zabbix
#some symlinks to startup the agent on machine boot
ln -s /etc/init.d/zabbix /etc/rc2.d/S84zabbix
ln -s /etc/init.d/zabbix /etc/rc3.d/S84zabbix
ln -s /etc/init.d/zabbix /etc/rc5.d/S84zabbix
ln -s /etc/init.d/zabbix /etc/rc4.d/S84zabbix

ln -s /etc/init.d/zabbix /etc/rc6.d/K15zabbix
ln -s /etc/init.d/zabbix /etc/rc0.d/K15zabbix
ln -s /etc/init.d/zabbix /etc/rc1.d/K15zabbix
