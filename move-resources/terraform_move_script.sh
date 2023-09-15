#/bin/bash

set -e


# Function to display usage information
usage() {
    echo "Usage: $0 <tfplan_file> <destroy_column> <create_column>"
    echo "  -h, --help    Display this help message"
    echo "  <tfplan_file> Path to the tfplan file to analyze"
    echo "  <destroy_column> Column to sort on destroyed resources"
    echo "  <create_column> Column to sort on created resources"
    exit 1
}

# Check for --help option
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    usage
fi

# Check for missing arguments
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing arguments. Use --help for usage information."
    exit 1
fi


if [ -z "$1" ]
then
    echo "missing arg \$1: No tfplan file argument supplied"
    exit 1
fi

if [ -z "$2" ]
then
  echo "missing arg \$2: column to sort on destroyed resources"
  exit 1
fi

if [ -z "$3" ]
then
  echo "missing arg \$3: column to sort on created resources"
  exit 1
fi


random_id=$(echo $RANDOM | md5sum | head -c 20; echo;)
move_file="move_file_${random_id}.tf"
tf_plan=$(terraform show -no-color $1)
destroy_targets="dt_${random_id}.txt"
echo "${tf_plan}" | grep destroyed | awk '{print $2}'| sort -k$2 -t "." > $destroy_targets

apply_targets="at_${random_id}.txt"
echo "${tf_plan}" | grep "will be created" | awk '{print $2}' | sort -k$3 -t "." | grep -v "=" > $apply_targets

num_lines_dt=$(wc -l $destroy_targets | awk '{print $1}')
num_lines_at=$(wc -l $apply_targets | awk '{print $1}')

if [[ $num_lines_at != $num_lines_dt ]]
then
  echo "sum of apply & destroy targets are not equal."
  echo $num_lines_at vs $num_lines_dt
  exit 1
fi

echo "" > $move_file
for tl in $(seq 1 $num_lines_at); do
  echo "moved {" >> $move_file
  echo "  from = $(sed -n ${tl}p $destroy_targets)" >> $move_file
  echo "  to = $(sed -n ${tl}p $apply_targets)" >> $move_file
  echo "}" >> $move_file
done;

rm $apply_targets
rm $destroy_targets
