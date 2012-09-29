# Ports

default[:tor][:listen] = '127.0.0.1:9050'
default[:privoxy][:listen] = '127.0.0.1:8118'

# Tor control interface

default[:tor][:controlport] = nil
default[:tor][:controlhash] = nil
