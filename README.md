## ANXS - monit [![Build Status](https://travis-ci.org/ANXS/monit.png)](https://travis-ci.org/ANXS/monit)

Ansible role which installs monit monitoring and management tool (and attaches it to ssh, cron, ntpd).


#### Requirements & Dependencies
- Tested on Ansible 1.4 or higher.


#### Variables

```yaml
monit_email_enable: yes
monit_notify_email: "me@localhost"

monit_logfile: "syslog facility log_daemon"

monit_poll_period: 60
monit_poll_start_delay: 120

monit_eventqueue_enable: yes
monit_eventqueue_directory: "/var/lib/monit/events"
monit_eventque_slots: 100

monit_mailformat_from: "monit@{{inventory_hostname}}"
monit_mailformat_subject: "$SERVICE $EVENT"
monit_mailformat_message: "Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION."

monit_mailserver_host: "localhost"
# monit_mailserver_port:
# monit_mailserver_username:
# monit_mailserver_password:
# monit_mailserver_encryption:
monit_mailserver_timeout: 60

monit_port: 3737
monit_address: "localhost"
monit_allow: ["localhost"]
# monit_username:
# monit_password:
monit_ssl: no
monit_cert: "/etc/monit/monit.pem"

monit_monitors_sshd_port: 22
```


#### Testing
This project comes with a VagrantFile, this is a fast and easy way to test changes to the role, fire it up with `vagrant up`

See [vagrant docs](https://docs.vagrantup.com/v2/) for getting setup with vagrant


#### License

Licensed under the MIT License. See the LICENSE file for details.


#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/ANXS/monit/issues)!
