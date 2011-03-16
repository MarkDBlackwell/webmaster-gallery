s_h=Signal.list
p s_h
p "parent is #{Process.ppid}, pid is #{Process.pid}"
signals=s_h.keys.sort
untrappable = %w[ VTALRM ]
(signals-untrappable).each do |e|
  Signal.trap e do
    p "#{e} received"
  end
end
sleep 10
