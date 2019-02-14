resource "vsphere_virtual_machine" "ubuntu" {
  name                 = "${var.hostname}"
  folder               = "${var.vsphere_folder}"
  firmware             = "bios" # must match template vm setting
  resource_pool_id     = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_cluster_id = "${data.vsphere_datastore_cluster.datastore_cluster.id}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.ubuntu-bionic-template.network_interface_types[0]}"
  }

  num_cpus = "${var.cpu_num}"
  memory   = "${var.mem}"
  guest_id = "${data.vsphere_virtual_machine.ubuntu-bionic-template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.ubuntu-bionic-template.scsi_type}"

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.ubuntu-bionic-template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.ubuntu-bionic-template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.ubuntu-bionic-template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.ubuntu-bionic-template.id}"

    customize {
      linux_options {
        host_name = "${var.hostname}"
        domain    = "${var.domain}"
      }

      network_interface {
        ipv4_address    = "${var.ip}"
        ipv4_netmask    = "${var.netmask}"
        dns_server_list = ["${var.dns_server}"]
      }

      ipv4_gateway = "${var.def_gw}"
    }
  }
}