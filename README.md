## [ANXS](https://github.com/ANXS) - monit

[![CI Status](https://img.shields.io/github/actions/workflow/status/anxs/monit/ci.yml)](https://github.com/ANXS/monit/actions/workflows/ci.yml)
[![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)](https://github.com/ANXS/monit)
[![Ansible Role](https://img.shields.io/ansible/role/d/anxs/monit)](https://galaxy.ansible.com/ui/standalone/roles/ANXS/monit/)
[![License](https://img.shields.io/github/license/ANXS/monit)](https://github.com/ANXS/monit/blob/master/LICENSE)

Ansible role for Monit 5.x on systemd-based Debian and Ubuntu hosts. It installs and enables Monit, renders process, network, and filesystem checks, validates the complete configuration before service changes, and retires checks previously managed by the role without touching unrelated files in the shared configuration directory.

## Requirements

* Ansible 2.14 or newer.
* Debian 12+ or Ubuntu 20.04+.
* systemd.

## Variables

The role monitors sshd and cron by default. When `monit_ntp_service` is `auto`, it also monitors the first running supported time service discovered from `systemd-timesyncd`, `chrony`, `ntp`, or `ntpsec`. Set the variable to one of those names to require a particular service.

Additional process checks use `monit_process_checks`:

```yaml
monit_process_checks:
  - name: web
    matching: "/usr/sbin/nginx"
    service: nginx
    action: restart
    port:
      number: 443
      protocol: https
      request: /health
      status: 200
      tls:
        verify: true
        ca_file: /etc/ssl/certs/internal-ca.pem
```

Each process check requires exactly one of `matching` or `pidfile`. If `service` is present, the generated start and stop actions use `systemctl`; explicit `start` and `stop` commands override them. Optional `cpu_percent`, `memory_percent`, `cycles`, and `every` fields add resource and scheduling controls. TLS port checks accept `verify`, `selfsigned`, `ca_file`, and Monit's `client_pem_file` option.

Network checks default to ICMP alerts:

```yaml
monit_network_checks:
  - name: upstream_dns
    address: "8.8.8.8"
    action: alert
    count: 3
    timeout: 3
```

Filesystem checks can alert on space or inode consumption:

```yaml
monit_filesystem_checks:
  - name: root
    path: /
    space_percent: 85
    inode_percent: 85
    cycles: 3
    action: alert
```

The legacy `monit_process_list` input remains accepted for migration. Its implicit start and stop actions are systemd-native; callers may retain explicit custom commands while moving to `monit_process_checks`.

See `defaults/main.yml` for mail, event queue, HTTP interface, and polling settings.

## Managed check retirement

The role stores the exact set of check fragments it manages below `monit_managed_state_dir`. On later runs it removes names that are no longer declared. Files absent from that manifest are preserved.

## Testing

Run `make test` for lint plus the public five-platform matrix, or use a platform target such as `make test-debian12`. Molecule verifies parser acceptance, zero-change idempotence, systemd service recovery through Monit, and managed-check retirement while preserving an operator-owned check.

## Note on AI usage

This project has been developed with AI assistance. Contributions using AI-generated content must be human reviewed and declared in the pull request or issue. Contributors remain responsible for explaining and defending the submitted work.

## License

MIT. See [LICENSE](LICENSE).

## Feedback

Issues and requests are welcome at [github.com/ANXS/monit](https://github.com/ANXS/monit/issues).
