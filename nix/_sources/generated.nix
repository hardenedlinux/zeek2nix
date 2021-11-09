# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "13b6654c75a032a79d35e21dcef3a926701e1c24";
    src = fetchFromGitHub ({
      owner = "cisagov";
      repo = "icsnpp-bacnet";
      rev = "13b6654c75a032a79d35e21dcef3a926701e1c24";
      fetchSubmodules = false;
      sha256 = "sha256-5WAT1wWB+wqCtGUaYD6GJehWRA1QSjMadMGmp28Q8fY=";
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
  zeek-latest = {
    pname = "zeek-latest";
    version = "c190c85bf0131e5eeab7d0cada4210050bfe2bf5";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "zeek";
      rev = "c190c85bf0131e5eeab7d0cada4210050bfe2bf5";
      fetchSubmodules = true;
      sha256 = "sha256-fDJigdPWSGykSvQu5h7L8idDUqQAZlhIsxcBJ0m2Ln8=";
    });
  };
  zeek-plugin-af_packet = {
    pname = "zeek-plugin-af_packet";
    version = "0075b3411fa859bae8965d0051608d07001e7b98";
    src = fetchFromGitHub ({
      owner = "J-Gras";
      repo = "zeek-af_packet-plugin";
      rev = "0075b3411fa859bae8965d0051608d07001e7b98";
      fetchSubmodules = false;
      sha256 = "sha256-pFhJSyhi5nJ9pd3tLYmfB3u7NgUyXEfmDSjEnSct3xM=";
    });
  };
  zeek-plugin-community-id = {
    pname = "zeek-plugin-community-id";
    version = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
    src = fetchFromGitHub ({
      owner = "corelight";
      repo = "zeek-community-id";
      rev = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
      fetchSubmodules = false;
      sha256 = "sha256-UDU6vGrpxwqtXd36oUhUKdGAV5c9LKpvoB/rcN/ICXY=";
    });
  };
  zeek-plugin-http2 = {
    pname = "zeek-plugin-http2";
    version = "7dc14042d1602065d60601d193b99b005f08fe34";
    src = fetchFromGitHub ({
      owner = "MITRECND";
      repo = "bro-http2";
      rev = "7dc14042d1602065d60601d193b99b005f08fe34";
      fetchSubmodules = false;
      sha256 = "sha256-EbO6WV1fcFtHRSaFkd/pPPNjMYkDeeZtn8KZHM3gug8=";
    });
  };
  zeek-plugin-ikev2 = {
    pname = "zeek-plugin-ikev2";
    version = "5b62d506573da388bb4df0446cc87cdffc12a438";
    src = fetchFromGitHub ({
      owner = "ukncsc";
      repo = "zeek-ikev2";
      rev = "5b62d506573da388bb4df0446cc87cdffc12a438";
      fetchSubmodules = false;
      sha256 = "sha256-ct1nQcbDGQ2V9lrKD/snhmF3EEkDXCbQfiJpSwOmKPI=";
    });
  };
  zeek-plugin-kafka = {
    pname = "zeek-plugin-kafka";
    version = "a2003110fe68e07a4f738b7c4ed440e07173ed84";
    src = fetchFromGitHub ({
      owner = "SeisoLLC";
      repo = "zeek-kafka";
      rev = "a2003110fe68e07a4f738b7c4ed440e07173ed84";
      fetchSubmodules = false;
      sha256 = "sha256-sui3z1mJshNqVErYtDiaQ97nbt+vu1FKvUSylxuNt5A=";
    });
  };
  zeek-plugin-pdf = {
    pname = "zeek-plugin-pdf";
    version = "3b52f87943f04685da600f4b00b4ad27f8cd28c6";
    src = fetchFromGitHub ({
      owner = "reservoirlabs";
      repo = "zeek-pdf-analyzer";
      rev = "3b52f87943f04685da600f4b00b4ad27f8cd28c6";
      fetchSubmodules = false;
      sha256 = "sha256-0zO7RwCJx8W8rn5ebjZUn/xLGl0M1ljCSNWSxawflLA=";
    });
  };
  zeek-plugin-postgresql = {
    pname = "zeek-plugin-postgresql";
    version = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
    src = fetchFromGitHub ({
      owner = "0xxon";
      repo = "zeek-postgresql";
      rev = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
      fetchSubmodules = false;
      sha256 = "sha256-Z5ImP8/WPcnfuXC8ZnE5ijERePRC6MdL12CiRuJJfTg=";
    });
  };
  zeek-plugin-spicy = {
    pname = "zeek-plugin-spicy";
    version = "073b94bc4f49c1920e7f0f78075e10160cadcbc1";
    src = fetchFromGitHub ({
      owner = "zeek";
      repo = "spicy-plugin";
      rev = "073b94bc4f49c1920e7f0f78075e10160cadcbc1";
      fetchSubmodules = false;
      sha256 = "sha256-eO1XyVkqBW7o6ztiKrrRwD9LnXihQ67Wv53qs1KoTkE=";
    });
  };
  zeek-plugin-zip = {
    pname = "zeek-plugin-zip";
    version = "df3344f1e161da9349d5257fc9137acc09d4af55";
    src = fetchFromGitHub ({
      owner = "reservoirlabs";
      repo = "zeek-zip-analyzer";
      rev = "df3344f1e161da9349d5257fc9137acc09d4af55";
      fetchSubmodules = false;
      sha256 = "sha256-1JKcDOVLQh9wyipGrVtmDnVrEXoMqjxtXqPs1rQo150=";
    });
  };
  zeek-release = {
    pname = "zeek-release";
    version = "4.1.1";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/releases/download/v4.1.1/zeek-4.1.1.tar.gz";
      sha256 = "sha256-jAr8mZqN0cH2d6XPgYR5uZwtUn5nnh75n7GwP5icA3M=";
    };
  };
  zeek-tls = {
    pname = "zeek-tls";
    version = "4.0.4";
    src = fetchurl {
      url = "https://github.com/zeek/zeek/releases/download/v4.0.4/zeek-4.0.4.tar.gz";
      sha256 = "sha256-2Zkd40T6jtjJLRMINzCWVdyeIsT15TwUHc5t7uXAUFw=";
    };
  };
}
