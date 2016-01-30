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

  defp assemble_fail_message(
    firewall_ip,
    input_interface,
    outcome,
    protocol,
    details,
    reason
  ) do
    "On interface '#{input_interface}', #{firewall_ip} #{outcome} "
      <> "#{protocol} #{details}\n"
      <> "  #{reason}\n"
  end

  defp fail_message(
    firewall_ip,
    input_interface,
    outcome,
    flow = %Flow.ICMP{},
    reason
  ) do
    assemble_fail_message(
      firewall_ip,
      input_interface,
      outcome,
      "ICMP type #{flow.type}, code #{flow.code}",
      "from #{flow.source} to #{flow.destination}",
      reason
    )
  end

  defp fail_message(
    firewall_ip,
    input_interface,
    outcome,
    flow = %{keyword: protocol},
    reason
  ) when protocol in ["tcp", "udp"] do
    details = "from #{flow.source}:#{flow.source_port} "
        <> "to #{flow.destination}:#{flow.destination_port}"

    assemble_fail_message(
      firewall_ip,
      input_interface,
      outcome,
      String.upcase(protocol),
      details,
      reason
    )
  end

  defp _trace_and_assert(firewall_ip, input_if, flow, assert_fun, outcome) do
    trace = NetworkTest.packet_tracer firewall_ip, input_if, flow
    message = ""

    if reason = trace.result.drop_reason do
      message = fail_message firewall_ip, input_if, outcome, flow, reason
    end

    assert_fun.(trace.result.action == "allow", message)
  end

  defp trace_and_assert(:allow, firewall_ip, input_if, flow) do
    _trace_and_assert firewall_ip, input_if, flow, &assert(&1, &2), "denied"
  end
  defp trace_and_assert(:deny, firewall_ip, input_if, flow) do
    _trace_and_assert firewall_ip, input_if, flow, &refute(&1, &2), "allowed"
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
    flow = Flow.flow :icmp, source, icmp_type, icmp_code, destination

    trace_and_assert :allow, firewall_ip, input_interface, flow
  end
  def assert_allow(
    firewall_ip,
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
  ) when protocol in [:tcp, :udp] do

    flow = Flow.flow protocol, source, source_port, destination, destination_port

    trace_and_assert :allow, firewall_ip, input_interface, flow
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
    flow = Flow.flow :icmp, source, icmp_type, icmp_code, destination

    trace_and_assert :deny, firewall_ip, input_interface, flow
  end
  def assert_deny(
    firewall_ip,
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
  ) when protocol in [:tcp, :udp] do

    flow = Flow.flow protocol, source, source_port, destination, destination_port

    trace_and_assert :deny, firewall_ip, input_interface, flow
  end
end
