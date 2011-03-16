a=[]
$".each do |e|
  es=e.to_s
  if es.start_with?('rubygems') && es.end_with?('.rb')
    a<<es
  end
end
b,a=a.partition{|e| e.include? 'rubygems/custom_require.rb'} 
[b,a].flatten.each{|e| load e}