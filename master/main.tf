provider "docker" {
  version = "2.6.0"
}

# postgres variables
variable "postgres_name" {
  default = "postgres-master"
}
variable "postgres_port" {
  default = "5432"
}

# network
resource "docker_network" "private_network" {
  name = "master"
}

# postgres container
resource "docker_container" "postgres-master" {
  name  = var.postgres_name
  hostname = var.postgres_name
  image = "postgres:12.3-alpine"
  restart = "always"

  env = [
    "POSTGRES_HOST_AUTH_METHOD=trust"
  ]

  volumes {
    host_path = abspath("./pgdata")
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path = abspath("./postgresql.conf")
    container_path = "/etc/postgresql/postgresql.conf"
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
