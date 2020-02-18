resource "digitalocean_droplet" "dnsmasq-server" {
    image 				= "ubuntu-14-04-x64"
    name 				= "dnsmasq-server"
    region 				= "lon1"
    size 				= "s-1vcpu-1gb"
    private_networking 	= true
    ssh_keys 			= [
		var.ssh_fingerprint
    ]
	connection {
		user 		= "root"
		type 		= "ssh"
		private_key = file(var.pvt_key)
		timeout 	= "2m"
		host    	= self.ipv4_address
	}
	provisioner "file" {
		source = "./dnsmasq.conf"
		destination = "/etc/dnsmasq.conf.new"
	}
	provisioner "remote-exec" {
		inline = [
			"export PATH=$PATH:/usr/bin",

			# install dnsmasq
			"sudo apt-get update -y",
			"sudo apt-get install -y dnsmasq",

			# configure dnsmasq
			"cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig",
			"cp /etc/dnsmasq.conf.new /etc/dnsmasq.conf",
			"rm /etc/dnsmasq.conf.new"
		]
	}
}
