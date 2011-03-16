p Time.now, 'in '+__FILE__

s="parent is #{Process.ppid}, process id is #{Process.pid}"
p s
Rails.logger.info s