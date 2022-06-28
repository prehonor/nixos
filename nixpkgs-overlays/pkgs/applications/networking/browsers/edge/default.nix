{
  beta = import ./browser.nix {
    channel = "beta";
    version = "97.0.1072.21";
    revision = "1";
    sha256 = "sha256:1jhhrz1jn8ivv105vjw7lwkv3k4kpwzhh0k8zf1lg3m1xibvlvas";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "97.0.1072.13";
    revision = "1";
    sha256 = "sha256:1iri1hv6albk8a8b0rfhbi9d29j6p6dpq454b9hdbgmpywpj40n2";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "96.0.1054.41";
    revision = "1";
    sha256 = "sha256:0v16db2c6lmqlyhrqhcpynjk8qq35j0gzy7xdsf496yxl7dryx1g";
  };
}
