@echo off
rem There is issue with Webrick on JRuby > 1.7.10 - server doesn't stop on Ctrl-C
rem https://github.com/jruby/jruby/issues/1115

rem This script is workaround which stops Webrick

set /p WEBRICK_PID=<%~dp0\..\tmp\pids\server.pid

taskkill /pid %WEBRICK_PID% /f && del "%~dp0\..\tmp\pids\server.pid"
