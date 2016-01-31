# Copyright © 2016 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

use Mix.Config

import_config "#{Mix.env}.exs"


config :network_test, NetworkTest.PacketTracer.SSH,
  user: "robot",
  password_path: "/home/jstorm/.ssh/robot_pass"

