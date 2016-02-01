# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest.PacketTracer.SSH do
  @behaviour NetworkTest.PacketTracer

  defp get_environment do
    Application.get_env :network_test, NetworkTest.PacketTracer.SSH, []
  end

  defp get_user do
    get_environment[:user]
  end

  defp get_password_path do
    get_environment[:password_path]
  end

  defp get_password do
    String.strip File.read!(get_password_path)
  end

  def packet_tracer(firewall_ip, input_if, flow) do
    trace_cmd = "packet-tracer input #{input_if} #{flow}"
    credential = [username: get_user, password: get_password]

    conn = SSHPTY.connect URI.parse("ssh://#{firewall_ip}"), credential

    try do
      cid = SSHPTY.get_shell conn

      _ = SSHPTY.send "term page 0", conn, cid, 100
      [{^trace_cmd, output}] = SSHPTY.send trace_cmd, conn, cid, 1000
      _ = SSHPTY.send "exit", conn, cid, 100

      output = Regex.replace ~r/^.*\r\n/, output, ""
      Regex.replace ~r/\r\n.*$/, output, ""

    after
      SSHPTY.disconnect conn
    end
  end
end
