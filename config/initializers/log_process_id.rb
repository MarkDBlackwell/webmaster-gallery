=begin
p Time.now, 'in '+__FILE__ unless STARTED_BY_TEST

unless STARTED_BY_TEST
  s="parent is #{Process.ppid}, process id is #{Process.pid}"
  p s
  Rails.logger.info s
end
=end
