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
      assert is_allowed(
        @device_under_test,
        unquote(input_interface),
        :icmp,
        unquote(source),
        unquote(icmp_type),
        unquote(icmp_code),
        unquote(destination)
      )
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
      assert is_allowed(
        @device_under_test,
        unquote(input_interface),
        unquote(protocol),
        unquote(source),
        unquote(source_port),
        unquote(destination),
        unquote(destination_port)
      )
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
      assert not is_allowed(
        @device_under_test,
        unquote(input_interface),
        :icmp,
        unquote(source),
        unquote(icmp_type),
        unquote(icmp_code),
        unquote(destination)
      )
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
      assert not is_allowed(
        @device_under_test,
        unquote(input_interface),
        unquote(protocol),
        unquote(source),
        unquote(source_port),
        unquote(destination),
        unquote(destination_port)
      )
    end
  end

  def is_allowed(
    firewall_ip,
    input_interface,
    :icmp,
    source,
    icmp_type,
    icmp_code,
    destination
  ) do
    NetworkTest.packet_tracer(
      firewall_ip,
      input_interface,
      :icmp,
      source,
      icmp_type,
      icmp_code,
      destination
    ).result.action == "allow"
  end
  def is_allowed(
    firewall_ip,
    input_interface,
    protocol,
    source,
    source_port,
    destination,
    destination_port
  ) when protocol in [:tcp, :udp] do
    NetworkTest.packet_tracer(
      firewall_ip,
      input_interface,
      protocol,
      source,
      source_port,
      destination,
      destination_port
    ).result.action == "allow"
  end
end
