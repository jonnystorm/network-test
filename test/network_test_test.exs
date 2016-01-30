# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTestTest do
  use ExUnit.Case
  doctest NetworkTest

  test "parses packet-tracer output" do
    phase1 = %PacketTrace.Phase{
      phase: 1,
      type: "ROUTE-LOOKUP",
      subtype: "Resolve Egress Interface",
      result: "ALLOW",
      config: "",
      additional_info: "found next-hop 192.0.2.1 using egress ifc  an_output_if\n\n"
    }
    phase2 = %PacketTrace.Phase{
      phase: 2,
      type: "UN-NAT",
      subtype: "static",
      result: "ALLOW",
      config: "nat (any,outside) source static SomeHost SomeHost destination static SomeSubnet SomeSubnet route-lookup\n",
      additional_info: "NAT divert to egress interface an_output_if
Untranslate 192.0.2.100/80 to 192.0.2.100/80\n\n"
    }
    phase3 = %PacketTrace.Phase{
      phase: 3,
      type: "ACCESS-LIST",
      subtype: "",
      result: "DROP",
      config: "Implicit Rule\n",
      additional_info: " Forward Flow based lookup yields rule:
 in  id=0x7fffde1286c0, priority=11, domain=permit, deny=true
        hits=60202233, user_data=0x6, cs_id=0x0, use_real_addr, flags=0x0, protocol=0
        src ip/id=0.0.0.0, mask=0.0.0.0, port=0, tag=any
        dst ip/id=0.0.0.0, mask=0.0.0.0, port=0, tag=any, dscp=0x0
        input_ifc=outside, output_ifc=any\n\n"
    }
    result = %PacketTrace.Result{
      input_interface: "outside",
      input_status: "up",
      input_line_status: "up",
      output_interface: "an_output_if",
      output_status: "up",
      output_line_status: "up",
      action: "drop",
      drop_reason: "(acl-drop) Flow is denied by configured rule"
    }

    assert NetworkTest.packet_tracer("", "outside", %Flow.ICMP{}) == 
      %PacketTrace{phases: [phase1, phase2, phase3], result: result}
  end
end
