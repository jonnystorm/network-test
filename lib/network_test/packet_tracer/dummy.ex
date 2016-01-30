# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule NetworkTest.PacketTracer.Dummy do
  @behaviour NetworkTest.PacketTracer

  def packet_tracer(_, input_interface, _) do
    "\r
Phase: 1\r
Type: ROUTE-LOOKUP\r
Subtype: Resolve Egress Interface\r
Result: ALLOW\r
Config:\r
Additional Information:\r
found next-hop 192.0.2.1 using egress ifc  an_output_if\r
\r
Phase: 2\r
Type: UN-NAT\r
Subtype: static\r
Result: ALLOW\r
Config:\r
nat (any,outside) source static SomeHost SomeHost destination static SomeSubnet SomeSubnet route-lookup\r
Additional Information:\r
NAT divert to egress interface an_output_if\r
Untranslate 192.0.2.100/80 to 192.0.2.100/80\r
\r
Phase: 3\r
Type: ACCESS-LIST\r
Subtype: \r
Result: DROP\r
Config:\r
Implicit Rule\r
Additional Information:\r
 Forward Flow based lookup yields rule:\r
 in  id=0x7fffde1286c0, priority=11, domain=permit, deny=true\r
        hits=60202233, user_data=0x6, cs_id=0x0, use_real_addr, flags=0x0, protocol=0\r
        src ip/id=0.0.0.0, mask=0.0.0.0, port=0, tag=any\r
        dst ip/id=0.0.0.0, mask=0.0.0.0, port=0, tag=any, dscp=0x0\r
        input_ifc=outside, output_ifc=any\r
\r
Result:\r
input-interface: #{input_interface}\r
input-status: up\r
input-line-status: up\r
output-interface: an_output_if\r
output-status: up\r
output-line-status: up\r
Action: drop\r
Drop-reason: (acl-drop) Flow is denied by configured rule\r
\r
\r
"
  end
end
