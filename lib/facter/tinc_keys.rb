require 'pathname'

nets = {}
Dir.glob('/etc/tinc/*').each do |net|
  netname = Pathname(net).each_filename.to_a[-1]
  if File.exists?("/etc/tinc/#{netname}/rsa_key.pub")
    key = IO.read("/etc/tinc/#{netname}/rsa_key.pub")
    nets[netname] = key
  end
end

nets.each do |net, key|
  Facter.add("tinckey_#{net}") do
    setcode do
      key
    end
  end
end
