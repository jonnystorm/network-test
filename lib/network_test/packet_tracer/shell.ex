# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest.PacketTracer.Shell do
  @behaviour NetworkTest.PacketTracer

  defp packet_tracer_path do
    Application.get_env(:network_test, NetworkTest.PacketTracer.Shell)[:path]
  end

  def packet_tracer(
    firewall_ip,
    input_if,
    :icmp,
    source,
    icmp_type,
    icmp_code,
    destination
  ) do

    {output, _} =
      System.cmd(
        packet_tracer_path,
        [ firewall_ip,
          input_if,
          "icmp",
          source,
          to_string(icmp_type),
          to_string(icmp_code),
          destination
        ],
        stderr_to_stdout: true
      )

    output
  end
  def packet_tracer(
    firewall_ip,
    input_if,
    protocol,
    source,
    source_port,
    destination,
    destination_port
  ) do

    {output, _} =
      System.cmd(
        packet_tracer_path,
        [ firewall_ip,
          input_if,
          to_string(protocol),
          source,
          to_string(source_port),
          destination,
          to_string(destination_port)
        ],
        stderr_to_stdout: true
      )

    output
  end
end
