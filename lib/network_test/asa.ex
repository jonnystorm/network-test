# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest.ASA do
  import ExUnit.Assertions

  defmacro __using__(_opts) do
    quote do
      import NetworkTest.ASA
    end
  end

  defmacro allow(
    input_interface,
    :icmp,
    type: icmp_type,
    code: icmp_code,
    from: source,
    to: destination
  ) do
    quote do
      assert_allow(
        @device_under_test,
        unquote(input_interface),
        :icmp,
        type: unquote(icmp_type),
        code: unquote(icmp_code),
        from: unquote(source),
        to: unquote(destination)
      )
    end
  end
  defmacro allow(
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
  ) do
    quote do
      assert_allow(
        @device_under_test,
        unquote(input_interface),
        unquote(protocol),
        from: unquote(source),
        port: unquote(source_port),
        to: unquote(destination),
        port: unquote(destination_port)
      )
    end
  end

  defmacro deny(
    input_interface,
    :icmp,
    type: icmp_type,
    code: icmp_code,
    from: source,
    to: destination
  ) do
    quote do
      assert_deny(
        @device_under_test,
        unquote(input_interface),
        :icmp,
        type: unquote(icmp_type),
        code: unquote(icmp_code),
        from: unquote(source),
        to: unquote(destination)
      )
    end
  end
  defmacro deny(
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
  ) do
    quote do
      assert_deny(
        @device_under_test,
        unquote(input_interface),
        unquote(protocol),
        from: unquote(source),
        port: unquote(source_port),
        to: unquote(destination),
        port: unquote(destination_port)
      )
    end
  end

  def assert_allow(
    firewall_ip,
    input_interface,
    :icmp,
    type: icmp_type,
    code: icmp_code,
    from: source,
    to: destination
  ) do
    trace = NetworkTest.packet_tracer(
      firewall_ip,
      input_interface,
      :icmp,
      source,
      icmp_type,
      icmp_code,
      destination
    )

    assert trace.result.action == "allow", (trace.result.drop_reason || "")
  end
  def assert_allow(
    firewall_ip,
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
  ) do
    trace = NetworkTest.packet_tracer(
      firewall_ip,
      input_interface,
      protocol,
      source,
      source_port,
      destination,
      destination_port
    )

    assert trace.result.action == "allow", (trace.result.drop_reason || "")
  end

  def assert_deny(
    firewall_ip,
    input_interface,
    :icmp,
    type: icmp_type,
    code: icmp_code,
    from: source,
    to: destination
  ) do
    trace = NetworkTest.packet_tracer(
      firewall_ip,
      input_interface,
      :icmp,
      source,
      icmp_type,
      icmp_code,
      destination
    )

    refute trace.result.action == "allow"
  end
  def assert_deny(
    firewall_ip,
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
  ) do
    trace = NetworkTest.packet_tracer(
      firewall_ip,
      input_interface,
      protocol,
      source,
      source_port,
      destination,
      destination_port
    )

    refute trace.result.action == "allow"
  end
end
