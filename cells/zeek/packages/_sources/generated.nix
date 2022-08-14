# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "aab668e86be5b56c5deaf4b11589937597a242de";
    src = fetchFromGitHub ({
      owner = "cisagov";
      repo = "icsnpp-bacnet";
      rev = "aab668e86be5b56c5deaf4b11589937597a242de";
      fetchSubmodules = false;
      sha256 = "sha256-5239chgjkQjX0zvc4TpMxfapBd/yivpmpi/DSl6lIlE=";
    });
  };
  netmap = {
    pname = "netmap";
    version = "af75adb951aae3f95e9c9fcf71ac35e9b21766b7";
    src = fetchFromGitHub ({
      owner = "luigirizzo";
      repo = "netmap";
      rev = "af75adb951aae3f95e9c9fcf71ac35e9b21766b7";
      fetchSubmodules = false;
      sha256 = "sha256-Uqe5lazu/lZokERiV0WKZI/m8WTLPeRVfJRJXcUTEM8=";
    });
  };
  zeek-af_packet = {
    pname = "zeek-af_packet";
    version = "8fec808efd9aa9f392fde644d5857ce498827db4";
    src = fetchFromGitHub ({
      owner = "J-Gras";
      repo = "zeek-af_packet-plugin";
      rev = "8fec808efd9aa9f392fde644d5857ce498827db4";
      fetchSubmodules = false;
      sha256 = "sha256-0ti8Aym6JTfm9pvGZxdd4lnc97WOceiRzJec8tgm4NY=";
    });
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
  };
  zeek-community-id = {
    pname = "zeek-community-id";
    version = "424a13eebf5efcc91dd77a9c5f762297fc2bba39";
    src = fetchFromGitHub ({
      owner = "corelight";
      repo = "zeek-community-id";
      rev = "424a13eebf5efcc91dd77a9c5f762297fc2bba39";
      fetchSubmodules = false;
      sha256 = "sha256-YDqeva8xkIj1emaqwh7Rohi6u5G3NuJfUW52iH9phTs=";
    });
  };
  zeek-http2 = {
    pname = "zeek-http2";
    version = "7dc14042d1602065d60601d193b99b005f08fe34";
    src = fetchFromGitHub ({
      owner = "MITRECND";
      repo = "bro-http2";
      rev = "7dc14042d1602065d60601d193b99b005f08fe34";
      fetchSubmodules = false;
      sha256 = "sha256-EbO6WV1fcFtHRSaFkd/pPPNjMYkDeeZtn8KZHM3gug8=";
    });
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
  };
  zeek-kafka = {
    pname = "zeek-kafka";
    version = "b632187c7afdc75365a256a7d9bb2e5cc81ab46f";
    src = fetchFromGitHub ({
      owner = "SeisoLLC";
      repo = "zeek-kafka";
      rev = "b632187c7afdc75365a256a7d9bb2e5cc81ab46f";
      fetchSubmodules = false;
      sha256 = "sha256-CJXnPam24gPx7Jd4CZJRsdUh7e4H5P7gaf/v2Q4xZ60=";
    });
  };
  zeek-latest = {
    pname = "zeek-latest";
    version = "148f5c1403c1485cae126de8350eb5cefa977e70";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "148f5c1403c1485cae126de8350eb5cefa977e70";
      fetchSubmodules = true;
      sha256 = "sha256-Aq2TOvFEr+2XO93kXJkgz3AyTRPgVC8RFBPEgFSPFdY=";
    });
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
  };
  zeek-release = {
    pname = "zeek-release";
    version = "v5.0.0";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "v5.0.0";
      fetchSubmodules = true;
      sha256 = "sha256-TApX0GgCGt4MedcI50/rX35Va53cpG1V4eP2Dm4aBaA=";
    });
  };
  zeek-spicy = {
    pname = "zeek-spicy";
    version = "bca0ba5e1f89dcd30f98cc0be8178308dc952bb9";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "spicy-plugin";
      rev = "bca0ba5e1f89dcd30f98cc0be8178308dc952bb9";
      fetchSubmodules = false;
      sha256 = "sha256-D7VP1S0hZtDIoYur/a/mujmEnkbXrjOaWw3yLsHl1JY=";
    });
  };
  zeek-tls = {
    pname = "zeek-tls";
    version = "5.0.0";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/archive/refs/tags/v5.0.0.tar.gz";
      sha256 = "sha256-UxSVgzp6QwIgMa4oY/RY0SQrPUdLrgc/it+ntvobjX0=";
    };
  };
}
