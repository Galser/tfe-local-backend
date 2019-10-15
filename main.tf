# DFemo for the local state and Git handling
resource "null_resource" "helloWorld" {
    provisioner "local-exec" {
        command = "echo hello world"
    }
}

