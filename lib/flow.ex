# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule Flow do
  @type t :: Flow.ICMP | Flow.TCP | Flow.UDP

  defmodule ICMP do
    defstruct(
      ip_protocol: 1,
      keyword: "icmp",
      source: nil,
      type: nil,
      code: nil,
      destination: nil
    )

    @type t :: %Flow.ICMP{
      ip_protocol: 1,
      keyword: String.t,
      source: String.t,
      type: 0..255,
      code: 0..255,
      destination: String.t
    }
  end

  defmodule TCP do
    defstruct(
      ip_protocol: 6,
      keyword: "tcp",
      source: nil,
      source_port: nil,
      destination: nil,
      destination_port: nil
    )

    @type t :: %Flow.TCP{
      ip_protocol: 6,
      keyword: String.t,
      source: String.t,
      source_port: 1..65535,
      destination: String.t,
      destination_port: 1..65535
    }
  end

  defmodule UDP do
    defstruct(
      ip_protocol: 17,
      keyword: "udp",
      source: nil,
      source_port: nil,
      destination: nil,
      destination_port: nil
    )

    @type t :: %Flow.UDP{
      ip_protocol: 17,
      keyword: String.t,
      source: String.t,
      source_port: 1..65535,
      destination: String.t,
      destination_port: 1..65535
    }
  end

  def flow(:icmp, source, type, code, destination)
      when is_binary(source)
        and is_binary(destination)
        and type in 0..255 and code in 0..255 do

    %Flow.ICMP{
      source: source,
      type: type,
      code: code,
      destination: destination
    }
  end
  def flow(:tcp, source, source_port, destination, destination_port)
      when is_binary(source)
        and is_binary(destination)
        and source_port in 1..65535 and destination_port in 1..65535 do

    %Flow.TCP{
      source: source,
      source_port: source_port,
      destination: destination,
      destination_port: destination_port
    }
  end
  def flow(:udp, source, source_port, destination, destination_port)
      when is_binary(source)
        and is_binary(destination)
        and source_port in 1..65535 and destination_port in 1..65535 do

    %Flow.UDP{
      source: source,
      source_port: source_port,
      destination: destination,
      destination_port: destination_port
    }
  end
end

defimpl String.Chars, for: Flow.ICMP do
  def to_string(f) do
    "#{f.keyword} #{f.source} #{f.type} #{f.code} #{f.destination}"
  end
end

defimpl String.Chars, for: Flow.TCP do
  def to_string(f) do
    "#{f.keyword} #{f.source} #{f.source_port} #{f.destination} #{f.destination_port}"
  end
end

defimpl String.Chars, for: Flow.UDP do
  def to_string(f) do
    "#{f.keyword} #{f.source} #{f.source_port} #{f.destination} #{f.destination_port}"
  end
end
