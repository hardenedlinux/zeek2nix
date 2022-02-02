# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit
, fetchurl
, fetchFromGitHub
}:
{
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "cebbee058aca6ef2c9d3dfbd9093138ea187ed35";
    src =
      fetchFromGitHub
        (
          {
            owner = "cisagov";
            repo = "icsnpp-bacnet";
            rev = "cebbee058aca6ef2c9d3dfbd9093138ea187ed35";
            fetchSubmodules = false;
            sha256 = "sha256-i+aVOgU1Q/9wrPAyarjTiqKKwfK1Ln30vV1g6dl+Z+k=";
          }
        );
  };
  zeek-agent = {
    pname = "zeek-agent";
    version = "c67772b3acbeb1b5d3d74349aee9e6a8521da983";
    src =
      fetchFromGitHub
        (
          {
            owner = "zeek";
            repo = "zeek-agent";
            rev = "c67772b3acbeb1b5d3d74349aee9e6a8521da983";
            fetchSubmodules = true;
            sha256 = "sha256-gqGt4yDLkU3J8vm8Gxroz1VUfssFsJJOaAScSUsEvic=";
          }
        );
  };
  zeek-latest = {
    pname = "zeek-latest";
    version = "0793a38cc5a237bea868e4b60dfbedfddb44972a";
    src =
      fetchFromGitHub
        (
          {
            owner = "zeek";
            repo = "zeek";
            rev = "0793a38cc5a237bea868e4b60dfbedfddb44972a";
            fetchSubmodules = true;
            sha256 = "sha256-7Z+aEJ8/40xuvIIhWbWn3mCQFua1X8cHolllrSuolgw=";
          }
        );
  };
  zeek-plugin-af_packet = {
    pname = "zeek-plugin-af_packet";
    version = "af219c493d279d178161f7eacf44543771cfa71e";
    src =
      fetchFromGitHub
        (
          {
            owner = "J-Gras";
            repo = "zeek-af_packet-plugin";
            rev = "af219c493d279d178161f7eacf44543771cfa71e";
            fetchSubmodules = false;
            sha256 = "sha256-xyjiHkBZKbSvV6dR6FrccSJtovNuzdZ7G1pUHfiQw4Q=";
          }
        );
  };
  zeek-plugin-community-id = {
    pname = "zeek-plugin-community-id";
    version = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
    src =
      fetchFromGitHub
        (
          {
            owner = "corelight";
            repo = "zeek-community-id";
            rev = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
            fetchSubmodules = false;
            sha256 = "sha256-UDU6vGrpxwqtXd36oUhUKdGAV5c9LKpvoB/rcN/ICXY=";
          }
        );
  };
  zeek-plugin-http2 = {
    pname = "zeek-plugin-http2";
    version = "7dc14042d1602065d60601d193b99b005f08fe34";
    src =
      fetchFromGitHub
        (
          {
            owner = "MITRECND";
            repo = "bro-http2";
            rev = "7dc14042d1602065d60601d193b99b005f08fe34";
            fetchSubmodules = false;
            sha256 = "sha256-EbO6WV1fcFtHRSaFkd/pPPNjMYkDeeZtn8KZHM3gug8=";
          }
        );
  };
  zeek-plugin-ikev2 = {
    pname = "zeek-plugin-ikev2";
    version = "5b62d506573da388bb4df0446cc87cdffc12a438";
    src =
      fetchFromGitHub
        (
          {
            owner = "ukncsc";
            repo = "zeek-ikev2";
            rev = "5b62d506573da388bb4df0446cc87cdffc12a438";
            fetchSubmodules = false;
            sha256 = "sha256-ct1nQcbDGQ2V9lrKD/snhmF3EEkDXCbQfiJpSwOmKPI=";
          }
        );
  };
  zeek-plugin-kafka = {
    pname = "zeek-plugin-kafka";
    version = "a2003110fe68e07a4f738b7c4ed440e07173ed84";
    src =
      fetchFromGitHub
        (
          {
            owner = "SeisoLLC";
            repo = "zeek-kafka";
            rev = "a2003110fe68e07a4f738b7c4ed440e07173ed84";
            fetchSubmodules = false;
            sha256 = "sha256-sui3z1mJshNqVErYtDiaQ97nbt+vu1FKvUSylxuNt5A=";
          }
        );
  };
  zeek-plugin-pdf = {
    pname = "zeek-plugin-pdf";
    version = "3b52f87943f04685da600f4b00b4ad27f8cd28c6";
    src =
      fetchFromGitHub
        (
          {
            owner = "reservoirlabs";
            repo = "zeek-pdf-analyzer";
            rev = "3b52f87943f04685da600f4b00b4ad27f8cd28c6";
            fetchSubmodules = false;
            sha256 = "sha256-0zO7RwCJx8W8rn5ebjZUn/xLGl0M1ljCSNWSxawflLA=";
          }
        );
  };
  zeek-plugin-postgresql = {
    pname = "zeek-plugin-postgresql";
    version = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
    src =
      fetchFromGitHub
        (
          {
            owner = "0xxon";
            repo = "zeek-postgresql";
            rev = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
            fetchSubmodules = false;
            sha256 = "sha256-Z5ImP8/WPcnfuXC8ZnE5ijERePRC6MdL12CiRuJJfTg=";
          }
        );
  };
  zeek-plugin-spicy = {
    pname = "zeek-plugin-spicy";
    version = "787007f85ee176d24cb792cd7de9d845f30bdf11";
    src =
      fetchFromGitHub
        (
          {
            owner = "zeek";
            repo = "spicy-plugin";
            rev = "787007f85ee176d24cb792cd7de9d845f30bdf11";
            fetchSubmodules = false;
            sha256 = "sha256-OyecgQecXdf4FYl6kRcM1UFqDDlTYFvjuxxvWhMslXE=";
          }
        );
  };
  zeek-plugin-zip = {
    pname = "zeek-plugin-zip";
    version = "df3344f1e161da9349d5257fc9137acc09d4af55";
    src =
      fetchFromGitHub
        (
          {
            owner = "reservoirlabs";
            repo = "zeek-zip-analyzer";
            rev = "df3344f1e161da9349d5257fc9137acc09d4af55";
            fetchSubmodules = false;
            sha256 = "sha256-1JKcDOVLQh9wyipGrVtmDnVrEXoMqjxtXqPs1rQo150=";
          }
        );
  };
  zeek-release = {
    pname = "zeek-release";
    version = "4.2.0";
    src =
      fetchurl
        {
          url = "https://github.com/zeek/zeek/releases/download/v4.2.0/zeek-4.2.0.tar.gz";
          sha256 = "sha256-jZoCjKn+x61KnkinY+KWBSOEz0AupM03FXe/8YPCdFE=";
        };
  };
  zeek-tls = {
    pname = "zeek-tls";
    version = "4.0.5";
    src =
      fetchurl
        {
          url = "https://github.com/zeek/zeek/archive/refs/tags/v4.0.5.tar.gz";
          sha256 = "sha256-GhMA5oDL0AHQys3knxAM7tVHtAVFkMDmsB3Is0CPGYg=";
        };
  };
}
