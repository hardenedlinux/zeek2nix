final: prev:
{
  zeek = prev.callPackage ./nix {KafkaPlugin = true; PostgresqlPlugin = true;
                               Http2Plugin = true; ikev2Plugin = true; communityIdPlugin = true;};
}
