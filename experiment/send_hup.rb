c='ruby handle_hup.rb'
pid=Process.fork
Process.exec c unless pid
p "Starting at pid #{pid}"
sleep 2
p "Stopping at pid #{pid}"
Process.kill 'HUP', pid
p Process.waitall
sleep 10
Process.exit
