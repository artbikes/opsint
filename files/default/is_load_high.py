#!/usr/bin/env python
loadavg = open('/proc/loadavg', 'r').read().split(' ')
if float(loadavg[1]) < 1.00:
  print "high"
else:
  print "normal"
