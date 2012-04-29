#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

f = File.open("test.xml")
doc = Nokogiri::XML(f)
f.close

hosts = doc.xpath('//host')
hosts.each do |host|
  next if(host.xpath('status').first.get_attribute('state') != 'up')

  address = host.xpath('address').first.get_attribute('addr')

  puts("Address = #{address}")

  host.xpath('ports/port').each do |port|
    next if(port.xpath('state').first.get_attribute('state') != 'open')

    service = port.xpath('service').first

    puts("  Port #{port.get_attribute('portid')} (#{service.get_attribute('name')}) is #{service.get_attribute('product')} #{service.get_attribute('version')}")

    port.xpath('script').each do |script|
      puts("    -> #{script.get_attribute('id')}:")
      puts("       #{script.get_attribute('output').sub("\n", "\n       ")}")
    end
  end
end

puts("Done!")
