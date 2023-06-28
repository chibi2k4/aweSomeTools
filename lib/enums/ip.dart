enum IpType {
  ipv4,
  ipv6;

  String getLocalhost() => this == ipv4 ? '127.0.0.1' : '0:0:0:0:0:0:0:1';

  @override
  String toString() =>
      "${name[0].toUpperCase()}${name[1].toUpperCase()}${name.substring(2).toLowerCase()}";
}
