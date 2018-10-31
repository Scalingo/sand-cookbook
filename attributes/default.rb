default["sand"] = {
  "download_url" => "https://github.com/Scalingo/sand/releases/download",
  "version" => "v0.3.0",
  "arch" => "amd64",
  "install_path" => "/usr/local/bin",
  "env" => {
    "rollbar_token" => "",
    "go_env" => "production",
    "netns_prefix" => "sc-ns-",
    "netns_path" => "/var/run/netns",
    "http_port" => 9999,
    "public_hostname" => "",
    "public_ip" => "",
    "etcd_prefix" => "/sc-net",
    "etcd_tls_cert" => "",
    "etcd_tls_key" => "",
    "etcd_tls_ca" => "",
    "http_tls_cert" => "",
    "http_tls_key" => "",
    "http_tls_ca" => "",
    "enabled_docker_plugin" => true,
    "docker_plugin_http_port" => 9998,
  }
}
