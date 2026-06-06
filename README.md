# Rudiment Calculator

Generate guitar rudiment practice PDFs from a text file containing tunes and rudiment definitions.

The application analyzes a source file, builds a histogram of rudiment usage, and generates a PDF containing practice material in a specified key.

## Requirements

* Ruby
* Bundler
* Prawn PDF library

Install dependencies:

```bash
bundle install
```

Or install Prawn directly:

```bash
gem install prawn
```

## Usage

```bash
ruby rudiment_calc.rb INPUT_FILE [options]
```

### Example

Generate 10 rudiments in the key of G and print the histogram:

```bash
ruby rudiment_calc.rb tunes.txt \
  --key G \
  --output_file G_rudiments.pdf \
  --print_histogram \
  --number_of_rudiments 10
```

### Short Form

```bash
ruby rudiment_calc.rb tunes.txt -k G -o G_rudiments.pdf -p -n 10
```

## Arguments

### INPUT_FILE

The text file used to generate the rudiment histogram.

Example:

```bash
ruby rudiment_calc.rb tunes.txt
```

## Options

| Option                              | Description                                | Default         |
| ----------------------------------- | ------------------------------------------ | --------------- |
| `-k`, `--key KEY`                   | Musical key for generated rudiments        | `C`             |
| `-n`, `--number_of_rudiments COUNT` | Number of rudiments to include in the PDF  | `10`            |
| `-o`, `--output_file FILE`          | Output PDF filename                        | `rudiments.pdf` |
| `-p`, `--print_histogram`           | Print histogram information to the console | `false`         |
| `-v`, `--verbose`                   | Enable verbose output                      | `false`         |

## Output

The program performs the following steps:

1. Reads the input file.
2. Generates a histogram of rudiment occurrences.
3. Optionally prints the histogram to the console.
4. Creates a PDF containing the requested number of rudiments.
5. Writes the PDF to the specified output file.

## Examples

### Generate a PDF in C

```bash
ruby rudiment_calc.rb tunes.txt
```

### Generate 25 rudiments in D

```bash
ruby rudiment_calc.rb tunes.txt \
  --key D \
  --number_of_rudiments 25 \
  --output_file d_rudiments.pdf
```

### Print Histogram Only

```bash
ruby rudiment_calc.rb tunes.txt -p
```

### Generate PDFs in Multiple Keys

```bash
#!/bin/bash

for key in C G D A E
do
  ruby rudiment_calc.rb tunes.txt \
    --key "$key" \
    --output_file "${key}_rudiments.pdf" \
    -p \
    -n 10
done
```

## Project Structure

```text
.
├── rudiment_calc.rb
├── histogram.rb
├── rudiment_pdf_generator.rb
└── tunes.txt
```

### Components

#### Histogram

Responsible for:

* Reading the input file
* Counting rudiment occurrences
* Producing histogram data
* Printing histogram information

#### RudimentPDFGenerator

Responsible for:

* Selecting rudiments for practice
* Rendering notation and layouts
* Generating the final PDF

## License

This project is licensed under the MIT License. See the LICENSE file for details.
