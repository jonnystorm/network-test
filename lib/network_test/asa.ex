defmodule NetworkTest.ASA do
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
  defmacro allow(
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
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

  defmacro deny(
    input_interface,
    :icmp,
    type: icmp_type,
    code: icmp_code,
    from: source,
    to: destination
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
  defmacro deny(
    input_interface,
    protocol,
    from: source,
    port: source_port,
    to: destination,
    port: destination_port
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
