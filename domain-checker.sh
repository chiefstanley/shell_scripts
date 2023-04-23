#!/bin/bash

# Define input and output files
input_file="domains.txt"

# Create timestamp for CSV file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Define output file with timestamp
output_file="results_$timestamp.csv"

# Create timestamp for CSV file
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Create header row for CSV file
echo "Domain,IP Address,Successful Connections" > $output_file

# Loop through each domain in input file
while read domain
do
  echo "Processing domain: $domain"

  # Run nping command and capture output
  nping_output=$(nping -c 1 $domain -p 443)

  # Retrieve IP address, target, and successful connection information
  ip_address=$(echo "$nping_output" | grep -oP "SENT.*\(\K[\d.]+(?=:443)")
  # Alternative AWK version
  # ip_address=$(echo "$nping_output" | awk 'match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) {print substr($0, RSTART, RLENGTH)}')

  # target=$(echo "$nping_output" | grep -oP "SENT .* > \K[\w.]+")
  successful_connections=$(echo "$nping_output" | grep -oP "Successful connections: \K[\d]+")

  # Append results to CSV file
  echo "$domain,$ip_address,$successful_connections" >> $output_file

  echo "Done processing domain: $domain"
done < $input_file

echo "All domains processed. Results written to $output_file."

