# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest.PacketTracer do
  @callback packet_tracer(
    String.t, String.t, :icmp, String.t, 0..255, 0..255, String.t
  ) :: String.t

  @callback packet_tracer(
    String.t, String.t, :tcp | :udp, String.t, 1..65535, String.t, 1..65535
  ) :: String.t
end
