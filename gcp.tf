provider "google" {
  credentials = file("credentials.json")
  project     = "chathangaming"
  region      = "us-west1"
}

resource "google_compute_instance" "jenkins-minikube" {
  name         = "jenkins-minikube"
  machine_type =  "custom-4-15360-ext"
  #zone         =   "${element(var.var_zones, count.index)}"
  zone          =   "us-west1-b"
  tags          = ["ssh","http","allow-8080"]
  boot_disk {
    initialize_params {
      image     =  "ubuntu-minimal-1804-bionic-v20200908"  
      size      =  "30"   
    }
  }
   network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }


metadata_startup_script = <<SCRIPT
        apt-get -y update
        apt-get -y install conntrack socat 
        curl -L get.docker.com | bash -
        docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home jenkins/jenkins
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
        sudo mkdir -p /usr/local/bin/
        sudo install minikube /usr/local/bin/
        minikube start --vm-driver=docker 
        SCRIPT

}
resource "google_compute_firewall" "jenkins-server" {
  name    = "allow-jenkins"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","8080"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server","allow-8080"]
}

