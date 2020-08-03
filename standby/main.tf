provider "docker" {
  version = "2.6.0"
}

# postgres variables
variable "postgres_name" {
  default = "postgres-standby"
}
variable "postgres_port" {
  default = "5432"
}

# network
resource "docker_network" "private_network" {
  name = "standby"
}

# autossh container
resource "docker_container" "autossh" {
  name  = "autossh"
  hostname = "autossh"
  image = "alpine:3.12.0"
  restart = "always"
  command = ["./autossh.sh"]

  volumes {
    host_path = abspath("./autossh.sh")
    container_path = "/autossh.sh"
  }

  volumes {
    host_path = abspath("./id_rsa")
    container_path = "/root/.ssh/id_rsa"
  }

  volumes {
    host_path = abspath("./id_rsa.pub")
    container_path = "/root/.ssh/id_rsa.pub"
  }

  ports {
    internal = "10000"
    external = "10000"
    ip = "127.0.0.1"
  }

  networks_advanced {
    name = docker_network.private_network.name
    aliases = ["autossh"]
  }
}

# postgres container
resource "docker_container" "postgres-standby" {
  name  = var.postgres_name
  hostname = var.postgres_name
  image = "postgres:12.3-alpine"
  restart = "always"
  command = ["./standby.sh"]

  env = [
    "POSTGRES_HOST_AUTH_METHOD=trust"
  ]

  volumes {
    host_path = abspath("../postgres-standby")
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path = abspath("./standby.sh")
    container_path = "/standby.sh"
  }

  ports {
    internal = "5432"
    external = var.postgres_port
    ip = "127.0.0.1"
  }

  networks_advanced {
    name = docker_network.private_network.name
    aliases = [var.postgres_name]
  }
}
