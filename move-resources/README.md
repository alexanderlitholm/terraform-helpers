# Terraform Plan Analyzer
This Bash script analyzes Terraform plan files to generate a list of resource movements. It helps identify resources that will be destroyed and created during a Terraform apply operation.

## Usage
```bash
./terraform-plan-analyzer.sh <tfplan_file> <destroy_column> <create_column>
``````
- <tfplan_file>: Path to the Terraform plan file to analyze.
- <destroy_column>: Column number to sort on for destroyed resources.
- <create_column>: Column number to sort on for created resources.
### Options
- -h, --help: Display this help message.

### Example
```bash
./terraform-plan-analyzer.sh my.tfplan 2 3
````
``
### Requirements
- Bash shell
- Terraform (for using terraform show)

### How it works
The script parses the Terraform plan file and identifies resources that will be destroyed and created during an apply operation. It then generates a report of resource movements in the move_file.tf.

