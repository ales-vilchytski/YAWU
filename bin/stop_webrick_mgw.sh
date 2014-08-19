# For MinGW or Cygwin

# There is issue with Webrick on JRuby > 1.7.10 - server doesn't stop on Ctrl-C
# https://github.com/jruby/jruby/issues/1115

# This script is workaround which stops Webrick

PID_FILE=$(dirname "$0")/../tmp/pids/server.pid
taskkill -pid $(cat $PID_FILE) -f && rm $PID_FILE