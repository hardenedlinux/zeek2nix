final: prev:
{
  zeek = prev.callPackage ./nix { KafkaPlugin = true; PostgresqlPlugin = true;
                                  Http2Plugin = true; Ikev2Plugin = true; CommunityIdPlugin = true;
                                  ZipPlugin = true; PdfPlugin = true;
                                };
}
