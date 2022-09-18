# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "0f7ded1e33d90d3e5c0aad90dbdc43508496d0bc";
    src = fetchFromGitHub ({
      owner = "cisagov";
      repo = "icsnpp-bacnet";
      rev = "0f7ded1e33d90d3e5c0aad90dbdc43508496d0bc";
      fetchSubmodules = false;
      sha256 = "sha256-20v2JYz9xiw6C3d/bWO9LvqR4dqn92OQ+jrip8Hl59w=";
    });
  };
  netmap = {
    pname = "netmap";
    version = "d89953a20a90e2df228ff5031ab4a5358f1cb8bc";
    src = fetchFromGitHub ({
      owner = "luigirizzo";
      repo = "netmap";
      rev = "d89953a20a90e2df228ff5031ab4a5358f1cb8bc";
      fetchSubmodules = false;
      sha256 = "sha256-CTmMrrP0XnwYFOzDNWhT1uzOfT3a+CPzKZ8HsQ0P29E=";
    });
  };
  zeek-af_packet = {
    pname = "zeek-af_packet";
    version = "7191152d14dfab0f6534263a180729b7be7b9011";
    src = fetchFromGitHub ({
      owner = "J-Gras";
      repo = "zeek-af_packet-plugin";
      rev = "7191152d14dfab0f6534263a180729b7be7b9011";
      fetchSubmodules = false;
      sha256 = "sha256-VLaPXFGOWslYsiK4xbcEtXqnzrp7kiQubxMKS9KhQEI=";
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
  zeek-dpdk = {
    pname = "zeek-dpdk";
    version = "e8d4febf8c1f9ef5f39c97e11988e059b5e715f4";
    src = fetchFromGitHub ({
      owner = "esnet";
      repo = "dpdk-plugin";
      rev = "e8d4febf8c1f9ef5f39c97e11988e059b5e715f4";
      fetchSubmodules = false;
      sha256 = "sha256-OjHqN25lZBVeIQjdbRcQ6944TrVWOo1gMQPZEydzoIQ=";
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
    version = "5389ad69f87f3a2533005b59cf55108d0b6de97b";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "5389ad69f87f3a2533005b59cf55108d0b6de97b";
      fetchSubmodules = true;
      sha256 = "sha256-PdUSicgLD67r4GWizOGH+UDYdGNQ9IaPAhxA77Ovi/8=";
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
    version = "v5.0.1";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "v5.0.1";
      fetchSubmodules = true;
      sha256 = "sha256-/yO0uf5O4lb2cgKnZUw77CizS9jyFg6RT7qLNFSF2Fw=";
    });
  };
  zeek-spicy = {
    pname = "zeek-spicy";
    version = "ab743fb55a3f45dc87c780f396e99b6227bbf25b";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "spicy-plugin";
      rev = "ab743fb55a3f45dc87c780f396e99b6227bbf25b";
      fetchSubmodules = false;
      sha256 = "sha256-o3J0UHCJNdbvH7wqNXnbYKRKG2FHtykgEb0rzzk43+U=";
    });
  };
  zeek-tls = {
    pname = "zeek-tls";
    version = "5.0.1";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/archive/refs/tags/v5.0.1.tar.gz";
      sha256 = "sha256-S6haCrTYptUA/bsk1A1JrayZdEMIYnMTGl/R4mYg49I=";
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
  };
}
