#!/usr/bin/env puma

environment 'production'

pidfile 'tmp/puma.pid'
state_path 'tmp/puma.state'

bind 'unix://tmp/puma.sock'

workers 2
