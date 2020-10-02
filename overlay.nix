final: prev:
{
  zeek = prev.callPackage ./. {KafkaPlugin = true; PostgresqlPlugin = true; Http2Plugin = true;};
}
