# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest.PacketTracer.Shell do
  @behaviour NetworkTest.PacketTracer

  defp packet_tracer_path do
    Application.get_env(:network_test, NetworkTest.PacketTracer.Shell)[:path]
  end

  def packet_tracer(firewall_ip, input_if, flow = %Flow.ICMP{}) do
    {output, _} =
      System.cmd(
        packet_tracer_path,
        [ firewall_ip,
          input_if,
          flow.keyword,
          flow.source,
          to_string(flow.type),
          to_string(flow.code),
          flow.destination
        ],
        stderr_to_stdout: true
      )

    output
  end
  def packet_tracer(firewall_ip, input_if, flow = %{keyword: protocol})
      when protocol in ["tcp", "udp"] do

    {output, _} =
      System.cmd(
        packet_tracer_path,
        [ firewall_ip,
          input_if,
          protocol,
          flow.source,
          to_string(flow.source_port),
          flow.destination,
          to_string(flow.destination_port)
        ],
        stderr_to_stdout: true
      )

    output
  end
end
