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
  spicy-analyzers = {
    pname = "spicy-analyzers";
    version = "b659d6d78571026a632ddcd84788fdd4c2140be7";
    src = fetchgit {
      url = "https://github.com/zeek/spicy-analyzers";
      rev = "b659d6d78571026a632ddcd84788fdd4c2140be7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "1zxb0aw53930xqhbfxrxh7yw8y0f58dfl7645q8b7l9a1fwd0bh4";
    };
  };
  zeek-master = {
    pname = "zeek-master";
    version = "d343dbbd7654f8183935d4690f0035ad7985dc56";
    src = fetchgit {
      url = "https://github.com/zeek/zeek";
      rev = "d343dbbd7654f8183935d4690f0035ad7985dc56";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "16lwgvxsjjpcb4r37ygkp2gqq65ah2f992fxj9sx2dqi6s5wbaas";
    };
  };
  zeek-plugin-community-id = {
    pname = "zeek-plugin-community-id";
    version = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
    src = fetchgit {
      url = "https://github.com/corelight/zeek-community-id";
      rev = "ea6df2b8c9c2fbb62cba8dba88d48a5c6a83e83a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0xh9r3gp1sqzl1pslb1xjxbq1l99ai4a3ynxbnnhmiz9day3ldah";
    };
  };
  zeek-plugin-http2 = {
    pname = "zeek-plugin-http2";
    version = "f4c4014a43c664e78d49b5ccc584d8e05e557e09";
    src = fetchgit {
      url = "https://github.com/MITRECND/bro-http2";
      rev = "f4c4014a43c664e78d49b5ccc584d8e05e557e09";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0djh7r9sksxvs5yf9vhszzyqh4f2qwj8knxyp2xk6ynnnj9ndp9d";
    };
  };
  zeek-plugin-ikev2 = {
    pname = "zeek-plugin-ikev2";
    version = "5b62d506573da388bb4df0446cc87cdffc12a438";
    src = fetchgit {
      url = "https://github.com/ukncsc/zeek-ikev2";
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
      url = "https://github.com/zeek/zeek/releases/download/v4.0.3/zeek-4.0.3.tar.gz";
      sha256 = "1nrkwaj0dilyzhfl6yma214vyakvpi97acyffdr7n4kdm4m6pvik";
    };
  };
}
