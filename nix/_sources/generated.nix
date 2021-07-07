# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl }:
{
  icsnpp-bacnet = {
    pname = "icsnpp-bacnet";
    version = "b4d9019a12fe927bb1653c9eb06ff7e14340eb61";
    src = fetchgit {
      url = "https://github.com/cisagov/icsnpp-bacnet";
      rev = "b4d9019a12fe927bb1653c9eb06ff7e14340eb61";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1szw6fpiff56jcir1mcj6fwjqwl8mrzpagph1wh88fcka1f224pv";
    };

  };
  spicy = {
    pname = "spicy";
    version = "8fdeb3be1965cf31badac68dd0031416dfe1dca3";
    src = fetchgit {
      url = "https://github.com/zeek/spicy";
      rev = "8fdeb3be1965cf31badac68dd0031416dfe1dca3";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1175jz3v6cbq4qb2apqdbksz9x1iknidwg1sab35d3lrchlay0iw";
    };

  };
  spicy-analyzers = {
    pname = "spicy-analyzers";
    version = "db91d5a98e55103303efe1d60f4530a885b72092";
    src = fetchgit {
      url = "https://github.com/zeek/spicy-analyzers";
      rev = "db91d5a98e55103303efe1d60f4530a885b72092";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1pgnk4xlj2jl5bdr2gbqg6fgrd30av2yj623jkw3kjf5f16c8arz";
    };

  };
  zeek-master = {
    pname = "zeek-master";
    version = "39f96d4720882fbe25f09cbda9b9831b1e4644cb";
    src = fetchgit {
      url = "https://github.com/zeek/zeek";
      rev = "39f96d4720882fbe25f09cbda9b9831b1e4644cb";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "108m4yh4f2vsxg7b2w85vmv8ql766ddr4prxl45ad6ra4c7p7k8d";
    };

  };
  zeek-plugin-community-id = {
    pname = "zeek-plugin-community-id";
    version = "fe6fdd079d166ab5750a2abce65cdb4938319748";
    src = fetchgit {
      url = "https://github.com/corelight/zeek-community-id";
      rev = "fe6fdd079d166ab5750a2abce65cdb4938319748";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "169xlk4dsyaz78gdx5rj6h1ll02f6rzq51zx3z497vpxcimg5n4m";
    };

  };
  zeek-plugin-http2 = {
    pname = "zeek-plugin-http2";
    version = "70008f0f40e6c942547285f8c43b9aabd1efc909";
    src = fetchgit {
      url = "https://github.com/MITRECND/bro-http2";
      rev = "70008f0f40e6c942547285f8c43b9aabd1efc909";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0x33k3ibbcssdpcwhnjaix114v07f2vya5zgr3ycca6dhyqmz4sj";
    };

  };
  zeek-plugin-ikev2 = {
    pname = "zeek-plugin-ikev2";
    version = "5b62d506573da388bb4df0446cc87cdffc12a438";
    src = fetchgit {
      url = "https://github.com/ukncsc/zeek-plugin-ikev2";
      rev = "5b62d506573da388bb4df0446cc87cdffc12a438";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1wi8lq1lns92gv82cp039487fqc64zxhzjjsysahs6f3qr0ngpbj";
    };

  };
  zeek-plugin-kafka = {
    pname = "zeek-plugin-kafka";
    version = "c9a3d869231ceb1ab871b3fa166e810dbf7e5d3c";
    src = fetchgit {
      url = "https://github.com/SeisoLLC/zeek-kafka";
      rev = "c9a3d869231ceb1ab871b3fa166e810dbf7e5d3c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "07sbvls174v04wk04f1g7xrqylsdzmp57b92vzixzgaq2cr1ydq3";
    };

  };
  zeek-plugin-pdf = {
    pname = "zeek-plugin-pdf";
    version = "3b52f87943f04685da600f4b00b4ad27f8cd28c6";
    src = fetchgit {
      url = "https://github.com/reservoirlabs/zeek-pdf-analyzer";
      rev = "3b52f87943f04685da600f4b00b4ad27f8cd28c6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1c4l3yncb4nm9315imhcbld4pz4zahv6wpkymsycbiw9013vncyk";
    };

  };
  zeek-plugin-postgresql = {
    pname = "zeek-plugin-postgresql";
    version = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
    src = fetchgit {
      url = "https://github.com/0xxon/zeek-postgresql";
      rev = "fa8e9acba569bcbf0046a8ae3d08cc069e847ac5";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0f3x97i4d8k0sx5wgs22yiw12cca75qndg3hp7gwjgfnrwzjd4k7";
    };

  };
  zeek-plugin-zip = {
    pname = "zeek-plugin-zip";
    version = "df3344f1e161da9349d5257fc9137acc09d4af55";
    src = fetchgit {
      url = "https://github.com/reservoirlabs/zeek-zip-analyzer";
      rev = "df3344f1e161da9349d5257fc9137acc09d4af55";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "17fp52sddv53brnkrahcg88nnx8fcrdssiiar9q1yhjbwl69r4nl";
    };

  };
  zeek-release = {
    pname = "zeek-release";
    version = "4.0.3";
    src = fetchurl {
      sha256 = "1nrkwaj0dilyzhfl6yma214vyakvpi97acyffdr7n4kdm4m6pvik";
      url = "https://github.com/zeek/zeek/releases/download/v4.0.3/zeek-4.0.3.tar.gz";
    };

  };
}
