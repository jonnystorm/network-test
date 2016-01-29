# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule PacketTrace do
  alias PacketTrace.{Phase, Result}

  defstruct phases: [], result: nil

  @type t :: %PacketTrace{phases: [Phase.t], result: Result.t}

  defmodule Phase do
    defstruct(
      phase: nil,
      type: nil,
      subtype: nil,
      result: nil,
      config: nil,
      additional_info: nil
    )

    @type t :: %Phase{
      phase: pos_integer,
      type: String.t,
      subtype: String.t,
      result: String.t,
      config: String.t,
      additional_info: String.t
    }
  end

  defmodule Result do
    defstruct(
      input_interface: nil,
      input_status: nil,
      input_line_status: nil,
      output_interface: nil,
      output_status: nil,
      output_line_status: nil,
      action: nil,
      drop_reason: nil
    )

    @type t :: %Result{
      input_interface: String.t,
      input_status: String.t,
      input_line_status: String.t,
      output_interface: String.t,
      output_status: String.t,
      output_line_status: String.t,
      drop_reason: String.t
    }
  end
end
