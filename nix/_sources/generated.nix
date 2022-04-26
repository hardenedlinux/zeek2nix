# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
}: {
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "be9aca1cf826010252a1516b5c2027ec68a6e88c";
    src = fetchFromGitHub {
      owner = "cisagov";
      repo = "icsnpp-bacnet";
      rev = "be9aca1cf826010252a1516b5c2027ec68a6e88c";
      fetchSubmodules = false;
      sha256 = "sha256-PBEZl8NL8IxQcj0CuxnSiI5wFksIHzgeZuw98SHR5U0=";
    };
  };
  zeek-agent = {
    pname = "zeek-agent";
    version = "c67772b3acbeb1b5d3d74349aee9e6a8521da983";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "zeek-agent";
      rev = "c67772b3acbeb1b5d3d74349aee9e6a8521da983";
      fetchSubmodules = true;
      sha256 = "sha256-gqGt4yDLkU3J8vm8Gxroz1VUfssFsJJOaAScSUsEvic=";
    };
  };
  zeek-latest = {
    pname = "zeek-latest";
    version = "4d24b9d9b86e59fcdcc806840f5716c93a372066";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "zeek";
      rev = "4d24b9d9b86e59fcdcc806840f5716c93a372066";
      fetchSubmodules = true;
      sha256 = "sha256-0trN6YuhpiGMXzqG4qY5dn1cR7uFOOHyCCLhMzdt3AE=";
    };
  };
  zeek-plugin-af_packet = {
    pname = "zeek-plugin-af_packet";
    version = "af219c493d279d178161f7eacf44543771cfa71e";
    src = fetchFromGitHub {
      owner = "J-Gras";
      repo = "zeek-af_packet-plugin";
      rev = "af219c493d279d178161f7eacf44543771cfa71e";
      fetchSubmodules = false;
      sha256 = "sha256-xyjiHkBZKbSvV6dR6FrccSJtovNuzdZ7G1pUHfiQw4Q=";
    };
  };
  zeek-plugin-community-id = {
    pname = "zeek-plugin-community-id";
    version = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
    src = fetchFromGitHub {
      owner = "corelight";
      repo = "zeek-community-id";
      rev = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
      fetchSubmodules = false;
      sha256 = "sha256-UDU6vGrpxwqtXd36oUhUKdGAV5c9LKpvoB/rcN/ICXY=";
    };
  };
  zeek-plugin-http2 = {
    pname = "zeek-plugin-http2";
    version = "7dc14042d1602065d60601d193b99b005f08fe34";
    src = fetchFromGitHub {
      owner = "MITRECND";
      repo = "bro-http2";
      rev = "7dc14042d1602065d60601d193b99b005f08fe34";
      fetchSubmodules = false;
      sha256 = "sha256-EbO6WV1fcFtHRSaFkd/pPPNjMYkDeeZtn8KZHM3gug8=";
    };
  };
  zeek-plugin-ikev2 = {
    pname = "zeek-plugin-ikev2";
    version = "5b62d506573da388bb4df0446cc87cdffc12a438";
    src = fetchFromGitHub {
      owner = "ukncsc";
      repo = "zeek-ikev2";
      rev = "5b62d506573da388bb4df0446cc87cdffc12a438";
      fetchSubmodules = false;
      sha256 = "sha256-ct1nQcbDGQ2V9lrKD/snhmF3EEkDXCbQfiJpSwOmKPI=";
    };
  };
  zeek-plugin-kafka = {
    pname = "zeek-plugin-kafka";
    version = "9c160d81b04373454494b3bcfe5170c9f741d759";
    src = fetchFromGitHub {
      owner = "SeisoLLC";
      repo = "zeek-kafka";
      rev = "9c160d81b04373454494b3bcfe5170c9f741d759";
      fetchSubmodules = false;
      sha256 = "sha256-aoIdKeNO833lT/WKQWsXuQqd3kzO5N13ONUScA3Xyao=";
    };
  };
  zeek-plugin-postgresql = {
    pname = "zeek-plugin-postgresql";
    version = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
    src = fetchFromGitHub {
      owner = "0xxon";
      repo = "zeek-postgresql";
      rev = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
      fetchSubmodules = false;
      sha256 = "sha256-Z5ImP8/WPcnfuXC8ZnE5ijERePRC6MdL12CiRuJJfTg=";
    };
  };
  zeek-plugin-spicy = {
    pname = "zeek-plugin-spicy";
    version = "0435d34acf92ff07558d72524fb2669eca78b1c9";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "spicy-plugin";
      rev = "0435d34acf92ff07558d72524fb2669eca78b1c9";
      fetchSubmodules = false;
      sha256 = "sha256-3WEmaFzSz8x4WdqwqCiTRs5lll3I95LMdxCUjZLDL8w=";
    };
  };
  zeek-release = {
    pname = "zeek-release";
    version = "4.2.1";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/releases/download/v4.2.1/zeek-4.2.1.tar.gz";
      sha256 = "sha256-axNImzBJTHxd2kU/xQmB5ZQ9ZxW2ybW3qFq7gLvm0RY=";
    };
  };
  zeek-tls = {
    pname = "zeek-tls";
    version = "4.2.1";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/archive/refs/tags/v4.2.1.tar.gz";
      sha256 = "sha256-iJ40RiZjTqdGgbdQDkfK1QQj715f3L8G5Ge3NKjB61Q=";
    };
  };
}
