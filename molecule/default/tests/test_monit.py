def test_monit_package(host):
    assert host.package("monit").is_installed


def test_monit_service(host):
    service = host.service("monit")
    assert service.is_enabled
    assert service.is_running


def test_monit_configuration_is_valid(host):
    result = host.run("monit -t")
    assert result.rc == 0, result.stderr


def test_monit_tracks_live_checks(host):
    result = host.run("monit summary")
    assert result.rc == 0, result.stderr
    for name in ("sshd", "cron", "molecule_http", "loopback", "rootfs"):
        assert name in result.stdout


def test_monit_recovers_systemd_service(host):
    service = host.service("molecule-http")
    assert service.is_running
    response = host.run(
        "python3 -c \"import urllib.request; "
        "urllib.request.urlopen('http://127.0.0.1:18080/', timeout=5).read()\""
    )
    assert response.rc == 0, response.stderr


def test_managed_retirement_preserves_operator_check(host):
    assert not host.file("/etc/monit/conf.d/process_retired_http.conf").exists
    assert host.file("/etc/monit/conf.d/operator-owned").is_file


def test_managed_manifest_matches_realized_state(host):
    manifest = host.file("/var/lib/monit/ansible-managed/configs.list")
    assert manifest.is_file
    names = set(manifest.content_string.strip().splitlines())
    assert "process_molecule_http.conf" in names
    assert "process_retired_http.conf" not in names
