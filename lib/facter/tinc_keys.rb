nets = {}
Dir.glob('/etc/tinc/*').each do |net|
  if File.exists?("/etc/tinc/#{net}/rsa_key.pub")
    key = IO.read("/etc/tinc/#{net}/rsa_key.pub")
    nets[net] = key
  end
end

nets.each do |net, key|
  Facter.add("tinckey_#{net}") do
    setcode do
      key
    end
  end
end
