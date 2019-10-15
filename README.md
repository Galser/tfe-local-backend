# tfe-local-backend
TF local state backend

Terraform , running from CLI with a local state file.  

# Requirements
This repo assumes general knowledge about Terraform for AWS, if not, please get yourself accustomed first by going through [getting started guide](https://learn.hashicorp.com/terraform?track=getting-started#getting-started).

# Instructions

- Start with empty Git repo
- Clone it to your computer, using tools of your choice
- Create new branch  (from here and later I am going to reference command-line Git tools) :
    ```
    git checkout -b f-create-code
    ``` 
- Create Terraform code, [main.tf](main.tf) with contents : 
    ```terraform
    # Demo for the local state and Git handling
    resource "null_resource" "helloWorld" {
        provisioner "local-exec" {
            command = "echo hello world"
        }
    }
    ```
- Init Terraform , execute :
    ```
    terraform init
    ```
    Output : 
    ```
    Initializing the backend...

    Initializing provider plugins...
    - Checking for available provider plugins...
    - Downloading plugin for provider "null" (hashicorp/null) 2.1.2...

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, it is recommended to add version = "..." constraints to the
    corresponding provider blocks in configuration, with the constraint strings
    suggested below.

    * provider.null: version = "~> 2.1"

    Terraform has been successfully initialized!    
    ```
- Apply our code : 
    ```
    terraform apply
    ```
    Output
    ```
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # null_resource.helloWorld will be created
    + resource "null_resource" "helloWorld" {
        + id = (known after apply)
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    null_resource.helloWorld: Creating...
    null_resource.helloWorld: Provisioning with 'local-exec'...
    null_resource.helloWorld (local-exec): Executing: ["/bin/sh" "-c" "echo hello world"]
    null_resource.helloWorld (local-exec): hello world
    null_resource.helloWorld: Creation complete after 0s [id=757830916550027386]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```
- Now, as we made "apply" action, we have in the current folder file with Terraform state , let's check what Git knows about it. and what had changed in our storage : 
    ```
    $ git status

    On branch f-create-code
    Untracked files:
    (use "git add <file>..." to include in what will be committed)

            .terraform/
            main.tf
            terraform.tfstate

    nothing added to commit but untracked files present (use "git add" to track)
    ```
    Indeed, we have some new untracked elements: 
    - our main code file - [main.tf](main.tf), this is expected.
    - new folder `.terraform` that for now contains binaries of plugins and helpers for you architecture : 
        ```
        tree .terraform 
        .terraform
        └── plugins
            └── darwin_amd64
                ├── lock.json
                └── terraform-provider-null_v2.1.2_x4

        2 directories, 2 files
        ```
    - new file `terraform.tfstate` - and this JSON-file that contains stat about our infrastructure and configuration. Potentially it can contain some sensitive data.
- We don't want to have *potentially sensitive data* to be committed into Git repo, and we also don't want to have temporary binaries specific only for local execution environment to be in source code repository. So recommendation is to avoid saving state files and local binaries in the repo. For this. let's create [.gitignore](.gitignore) file with content :
    ```
    .terraform
    terraform.tfstate*
    ```
> Note , that we have terraform.state* - defined with asterisk (*) pattern match, that's done on purpose, as with possible evolving of our infrastructure we can have terrafrom.tfstate.backup* . 
- Let's add our files into project : 
    ```
    git add .gitignore main.tf 
    ```
    And commit them : 
    ```
    git commit -m "Adding main code (main.tf) and gitignore"
    [f-create-code 82d7cd9] Adding main code (main.tf) and gitignore
    2 files changed, 9 insertions(+)
    create mode 100644 .gitignore
    create mode 100644 main.tf
    ```
- Now, let's check again status of the repo : 
    ```
    $ git status
    On branch f-create-code
    Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)

            modified:   README.md

    no changes added to commit (use "git add" and/or "git commit -a")
    ```
    Well, we have README, that we editing in parallel with our code, but Git not reporting anymore `.terraform` folder and `*.tfstate` files
- Pushing code to GitHub :
    ```
    $ git push --set-upstream origin f-create-code
    Enumerating objects: 5, done.
    Counting objects: 100% (5/5), done.
    Delta compression using up to 12 threads
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (4/4), 514 bytes | 514.00 KiB/s, done.
    Total 4 (delta 0), reused 0 (delta 0)
    remote: 
    remote: Create a pull request for 'f-create-code' on GitHub by visiting:
    remote:      https://github.com/Galser/tfe-local-backend/pull/new/f-create-code
    remote: 
    To github.com:Galser/tfe-local-backend.git
    * [new branch]      f-create-code -> f-create-code
    Branch 'f-create-code' set up to track remote branch 'f-create-code' from 'origin'.
    ```
- We do merge with pull request at GitHUb web UI
- Switch to master and pull merged code : 
  ```
  $ git checkout master
  Switched to branch 'master'
  Your branch is up to date with 'origin/master'.

  $ git pull
  remote: Enumerating objects: 1, done.
  remote: Counting objects: 100% (1/1), done.
  remote: Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
  Unpacking objects: 100% (1/1), done.
  From github.com:Galser/tfe-local-backend
     9aaf079..7c4c603  master     -> origin/master
  Updating 9aaf079..7c4c603
  Fast-forward
   .gitignore | 2 ++
   main.tf    | 7 +++++++
   2 files changed, 9 insertions(+)
   create mode 100644 .gitignore
   create mode 100644 main.tf
  ```
- Make final updates with merge via PR of README

# Todo


# Done
- [x] - make code and PR
- [x] - update README



