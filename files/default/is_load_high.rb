#!/usr/bin/env ruby
loadavg = File.read('/proc/loadavg').split(' ')
if loadavg[1].to_f < 1.00
  puts "high"
else
  puts "normal"
end
EOF
