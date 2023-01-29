# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "43c7b892c4f271f398feb406184473b432c45bb2";
    src = fetchFromGitHub ({
      owner = "cisagov";
      repo = "icsnpp-bacnet";
      rev = "43c7b892c4f271f398feb406184473b432c45bb2";
      fetchSubmodules = false;
      sha256 = "sha256-B0Z+3HMKCzRiIZF0Zs8U0GTacAgSmVSUaUNAqGD3Fg0=";
    });
    date = "2022-11-10";
  };
  netmap = {
    pname = "netmap";
    version = "439ea2dfda451ab9920334836b9b97dfab4fc353";
    src = fetchFromGitHub ({
      owner = "luigirizzo";
      repo = "netmap";
      rev = "439ea2dfda451ab9920334836b9b97dfab4fc353";
      fetchSubmodules = false;
      sha256 = "sha256-6hh6Ma80ZDSXJzArmi/WxwBHYENEpw44hexSqj2+Ubs=";
    });
    date = "2023-01-24";
  };
  zeek-af_packet = {
    pname = "zeek-af_packet";
    version = "b8c17c898bedfe020056027036f5a7eabc815c92";
    src = fetchFromGitHub ({
      owner = "J-Gras";
      repo = "zeek-af_packet-plugin";
      rev = "b8c17c898bedfe020056027036f5a7eabc815c92";
      fetchSubmodules = false;
      sha256 = "sha256-ZERMZE1VEi79JxFevkp9A50pqUjjvM+1ot+d70x4nSc=";
    });
    date = "2023-01-11";
  };
  zeek-agent = {
    pname = "zeek-agent";
    version = "c67772b3acbeb1b5d3d74349aee9e6a8521da983";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek-agent";
      rev = "c67772b3acbeb1b5d3d74349aee9e6a8521da983";
      fetchSubmodules = true;
      sha256 = "sha256-gqGt4yDLkU3J8vm8Gxroz1VUfssFsJJOaAScSUsEvic=";
    });
    date = "2020-11-19";
  };
  zeek-community-id = {
    pname = "zeek-community-id";
    version = "1ff02dec33b526d342ff025b49feee331e79f1cf";
    src = fetchFromGitHub ({
      owner = "corelight";
      repo = "zeek-community-id";
      rev = "1ff02dec33b526d342ff025b49feee331e79f1cf";
      fetchSubmodules = false;
      sha256 = "sha256-0aGurLs9h+U7ex8w0YZBMHAQx9wU7PQZXK3S/G7mRsg=";
    });
    date = "2023-01-12";
  };
  zeek-dpdk = {
    pname = "zeek-dpdk";
    version = "c22ea7e2fd59bc03c646970f6fb3da10d43585a8";
    src = fetchFromGitHub ({
      owner = "esnet";
      repo = "dpdk-plugin";
      rev = "c22ea7e2fd59bc03c646970f6fb3da10d43585a8";
      fetchSubmodules = false;
      sha256 = "sha256-42KFlcSjaZea7faPeP3HpndVSoDMAGjlrsPSVyj4TYc=";
    });
    date = "2022-11-15";
  };
  zeek-http2 = {
    pname = "zeek-http2";
    version = "929c46a787c553f05a755f999d78c53eb79583d1";
    src = fetchFromGitHub ({
      owner = "MITRECND";
      repo = "bro-http2";
      rev = "929c46a787c553f05a755f999d78c53eb79583d1";
      fetchSubmodules = false;
      sha256 = "sha256-K/gyqtVafHkTd/dfZPESjN9KLKbg5TlzJvJ9Htr/HA4=";
    });
    date = "2023-01-18";
  };
  zeek-ikev2 = {
    pname = "zeek-ikev2";
    version = "5b62d506573da388bb4df0446cc87cdffc12a438";
    src = fetchFromGitHub ({
      owner = "ukncsc";
      repo = "zeek-ikev2";
      rev = "5b62d506573da388bb4df0446cc87cdffc12a438";
      fetchSubmodules = false;
      sha256 = "sha256-ct1nQcbDGQ2V9lrKD/snhmF3EEkDXCbQfiJpSwOmKPI=";
    });
    date = "2020-01-27";
  };
  zeek-kafka = {
    pname = "zeek-kafka";
    version = "39e9dbfdb924f1fb309dc1323f5963a244aa5551";
    src = fetchFromGitHub ({
      owner = "SeisoLLC";
      repo = "zeek-kafka";
      rev = "39e9dbfdb924f1fb309dc1323f5963a244aa5551";
      fetchSubmodules = false;
      sha256 = "sha256-8HD3K10QefxOF7ydd1k60nhg0z5WVG+mmSxBahOuagM=";
    });
    date = "2022-12-03";
  };
  zeek-latest = {
    pname = "zeek-latest";
    version = "a1b003a9e2d0bc2960b766ad3a82c0c9de6c65e3";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "a1b003a9e2d0bc2960b766ad3a82c0c9de6c65e3";
      fetchSubmodules = true;
      sha256 = "sha256-EmU8jeLRBMrvnq9YE2kL0TC/6ayEwLsXMvSVgFoG3aQ=";
    });
    date = "2023-01-28";
  };
  zeek-netmap = {
    pname = "zeek-netmap";
    version = "9a4d77d0ecd71c72b4e27579dc68c753139ae2c8";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek-netmap";
      rev = "9a4d77d0ecd71c72b4e27579dc68c753139ae2c8";
      fetchSubmodules = false;
      sha256 = "sha256-yObo/IFaPVwSkprCjL1ehjU3HS+PqmjN2cuXf6bQDl4=";
    });
    date = "2022-06-07";
  };
  zeek-postgresql = {
    pname = "zeek-postgresql";
    version = "b2b70900a3b4779efbcb9a39eae8cab1d714f97f";
    src = fetchFromGitHub ({
      owner = "0xxon";
      repo = "zeek-postgresql";
      rev = "b2b70900a3b4779efbcb9a39eae8cab1d714f97f";
      fetchSubmodules = false;
      sha256 = "sha256-O2yWL2Ippv5GFxSesv7Eclw78p2YnT3UWnZ8W54NMdc=";
    });
    date = "2022-07-06";
  };
  zeek-release = {
    pname = "zeek-release";
    version = "v5.1.1";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "v5.1.1";
      fetchSubmodules = true;
      sha256 = "sha256-K1rwW9SHBNQ7Z1AP0CvSt1ZYkf2P5Pzqw76vNH+fVVI=";
    });
  };
  zeek-spicy = {
    pname = "zeek-spicy";
    version = "25cf1a83f10e0b5c81eea37e03beeda6035df5ba";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "spicy-plugin";
      rev = "25cf1a83f10e0b5c81eea37e03beeda6035df5ba";
      fetchSubmodules = false;
      sha256 = "sha256-TkuEDpJJsomHWfFYqjiWP4di9vG1dzEtLQvFkOArp0I=";
    });
    date = "2023-01-28";
  };
  zeek-tls = {
    pname = "zeek-tls";
    version = "5.0.5";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/archive/refs/tags/v5.0.5.tar.gz";
      sha256 = "sha256-15IqQqlXngT6C9x1pOihROXnkjitWqxGkRCA5m5uigw=";
    };
  };
  zeek-xdp_packet = {
    pname = "zeek-xdp_packet";
    version = "a550256ba92cbddff392fbb01cf8fcbe6e945850";
    src = fetchFromGitHub ({
      owner = "0xxon";
      repo = "zeek-xdp_packet-plugin";
      rev = "a550256ba92cbddff392fbb01cf8fcbe6e945850";
      fetchSubmodules = false;
      sha256 = "sha256-ghDDSCAxaiaDuygJemGUm1Uq+aKac2MNc2dW84i7qSo=";
    });
    date = "2021-04-27";
  };
}
