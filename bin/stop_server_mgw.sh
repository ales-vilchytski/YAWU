# For MinGW or Cygwin

# There is issue with rails server on JRuby > 1.7.10 - server doesn't stop on Ctrl-C
# https://github.com/jruby/jruby/issues/1115

# This script is workaround which stops server

PID_FILE=$(dirname "$0")/../tmp/pids/server.pid
taskkill -pid $(cat $PID_FILE) -f
rm $PID_FILE

exit 0 # nothing wrong if there is no PID_FILE or process has been already killed
