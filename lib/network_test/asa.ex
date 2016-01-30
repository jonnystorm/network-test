defmodule NetworkTest.ASA do
  defmacro __using__(_opts) do
    quote do
      import NetworkTest.ASA
    end
  end

  defmacro assert_allow(
    input_interface,
    :icmp,
    source,
    icmp_type,
    icmp_code,
    destination
  ) do
    quote do
      trace = NetworkTest.packet_tracer(
        @device_under_test,
        unquote(input_interface),
        :icmp,
        unquote(source),
        unquote(icmp_type),
        unquote(icmp_code),
        unquote(destination)
      )

      assert trace.result.action == "allow", (trace.result.drop_reason || "")
    end
  end
  defmacro assert_allow(
    input_interface,
    protocol,
    source,
    source_port,
    destination,
    destination_port
  ) do
    quote do
      trace = NetworkTest.packet_tracer(
        @device_under_test,
        unquote(input_interface),
        unquote(protocol),
        unquote(source),
        unquote(source_port),
        unquote(destination),
        unquote(destination_port)
      )

      assert trace.result.action == "allow", (trace.result.drop_reason || "")
    end
  end

  defmacro assert_deny(
    input_interface,
    :icmp,
    source,
    icmp_type,
    icmp_code,
    destination
  ) do
    quote do
      trace = NetworkTest.packet_tracer(
        @device_under_test,
        unquote(input_interface),
        :icmp,
        unquote(source),
        unquote(icmp_type),
        unquote(icmp_code),
        unquote(destination)
      )

      refute trace.result.action == "allow"
    end
  end
  defmacro assert_deny(
    input_interface,
    protocol,
    source,
    source_port,
    destination,
    destination_port
  ) do
    quote do
      trace = NetworkTest.packet_tracer(
        @device_under_test,
        unquote(input_interface),
        unquote(protocol),
        unquote(source),
        unquote(source_port),
        unquote(destination),
        unquote(destination_port)
      )

      refute trace.result.action == "allow"
    end
  end
end
