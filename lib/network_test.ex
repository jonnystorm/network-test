# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest do
  defp _parse_phase(
    output = ["Result:" | _tail],
    { phase = %PacketTrace.Phase{
        config: <<_ :: binary>>,
        additional_info: <<_ :: binary>>
      },
      phases
    }
  ) do
    _parse_packet_tracer_output output, {nil, phases ++ [phase]}
  end
  defp _parse_phase(
    output = [<<"Phase: ", _ :: binary>> | _tail],
    { phase = %PacketTrace.Phase{
        config: <<_ :: binary>>,
        additional_info: <<_ :: binary>>
      },
      phases
    }
  ) do
    _parse_packet_tracer_output output, {nil, phases ++ [phase]}
  end
  defp _parse_phase(
    ["Additional Information:" | tail],
    {phase = %PacketTrace.Phase{}, phases}
  ) do
    phase = %{phase | additional_info: ""}

    _parse_phase tail, {phase, phases}
  end
  defp _parse_phase(
    ["Config:" | tail],
    {phase = %PacketTrace.Phase{}, phases}
  ) do
    phase = %{phase | config: ""}

    _parse_phase tail, {phase, phases}
  end
  defp _parse_phase(
    [<<"Result: ", result :: binary>> | tail],
    {phase = %PacketTrace.Phase{}, phases}
  ) do
    phase = %{phase | result: result}

    _parse_phase tail, {phase, phases}
  end
  defp _parse_phase(
    [<<"Subtype: ", subtype :: binary>> | tail],
    {phase = %PacketTrace.Phase{}, phases}
  ) do
    phase = %{phase | subtype: subtype}

    _parse_phase tail, {phase, phases}
  end
  defp _parse_phase(
    [<<"Type: ", type :: binary>> | tail],
    {phase = %PacketTrace.Phase{}, phases}
  ) do
    phase = %{phase | type: type}

    _parse_phase tail, {phase, phases}
  end
  defp _parse_phase(
    [<<line:: binary>> | tail],
    { phase = %PacketTrace.Phase{
        config: <<_ :: binary>>,
        additional_info: <<info :: binary>>
      },
      phases
    }
  ) do
    phase = %{phase | additional_info: info <> "#{line}\n"}

    _parse_phase tail, {phase, phases}
  end
  defp _parse_phase(
    [<<line:: binary>> | tail],
    { phase = %PacketTrace.Phase{
        config: <<config :: binary>>,
        additional_info: nil
      },
      phases
    }
  ) do
    phase = %{phase | config: config <> "#{line}\n"}

    _parse_phase tail, {phase, phases}
  end


  defp _parse_result(
    ["" | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    _parse_packet_tracer_output tail, {nil, [result | phases]}
  end
  defp _parse_result(
    [<<"Drop-reason: ", drop_reason :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | drop_reason: drop_reason}

    _parse_packet_tracer_output tail, {nil, [result | phases]}
  end
  defp _parse_result(
    [<<"Action: ", action :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | action: action}

    _parse_result tail, {result, phases}
  end
  defp _parse_result(
    [<<"output-line-status: ", output_line_status :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | output_line_status: output_line_status}

    _parse_result tail, {result, phases}
  end
  defp _parse_result(
    [<<"output-status: ", output_status :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | output_status: output_status}

    _parse_result tail, {result, phases}
  end
  defp _parse_result(
    [<<"output-interface: ", output_interface :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | output_interface: output_interface}

    _parse_result tail, {result, phases}
  end
  defp _parse_result(
    [<<"input-line-status: ", input_line_status :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | input_line_status: input_line_status}

    _parse_result tail, {result, phases}
  end
  defp _parse_result(
    [<<"input-status: ", input_status :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | input_status: input_status}

    _parse_result tail, {result, phases}
  end
  defp _parse_result(
    [<<"input-interface: ", input_interface :: binary>> | tail],
    {result = %PacketTrace.Result{}, phases}
  ) do
    result = %{result | input_interface: input_interface}

    _parse_result tail, {result, phases}
  end


  defp _parse_packet_tracer_output([], {nil, result_and_phases}) do
    result_and_phases
  end
  defp _parse_packet_tracer_output(["" | tail], acc = {nil, _}) do
    _parse_packet_tracer_output tail, acc
  end
  defp _parse_packet_tracer_output(
    ["Result:" | tail],
    {nil, phases}
  ) do
    new_result = %PacketTrace.Result{}

    _parse_result tail, {new_result, phases}
  end
  defp _parse_packet_tracer_output(
    [<<"Phase: ", phase :: binary>> | tail],
    {nil, phases}
  ) do
    new_phase = %PacketTrace.Phase{phase: String.to_integer(phase)}

    _parse_phase tail, {new_phase, phases}
  end
  defp _parse_packet_tracer_output([<<_ :: binary>> | tail], acc) do
    _parse_packet_tracer_output tail, acc
  end


  defp packet_trace(phases, result = %PacketTrace.Result{}) when is_list phases do
    %PacketTrace{phases: phases, result: result}
  end

  defp parse_packet_tracer_output(output) when is_binary output do
    [result | phases] =
      output
        |> String.split("\r\n")
        |> _parse_packet_tracer_output({nil, []})

    packet_trace phases, result
  end

  defp get_packet_tracer do
    Application.get_env :network_test, :packet_tracer
  end

  @spec packet_tracer(String.t, String.t, Flow.t) :: PacketTrace.t
  def packet_tracer(firewall_ip, input_interface, flow)
      when is_binary(firewall_ip) and is_binary(input_interface) do

    get_packet_tracer.packet_tracer(firewall_ip, input_interface, flow)
      |> parse_packet_tracer_output
  end
end
