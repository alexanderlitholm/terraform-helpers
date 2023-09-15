# Terraform Resource Mover
This Bash script moves Terraform plan files to generate a list of resource movements. It helps identify resources that will be destroyed and created during a Terraform apply operation.

## Usage
```bash
./terraform-move-script.sh <tfplan_file> <destroy_column> <create_column>
``````
- <tfplan_file>: Path to the Terraform plan file to move.
- <destroy_column>: Column number to sort on for destroyed resources.
- <create_column>: Column number to sort on for created resources.
### Options
- -h, --help: Display this help message.

### Example
```bash
./terraform-move-script.sh my.tfplan 2 3
````
``
### Requirements
- Bash shell
- Terraform (for using terraform show)

### How it works
The script parses the Terraform plan file and identifies resources that will be destroyed and created during an apply operation. It then generates a report of resource movements in the move_file.tf.

