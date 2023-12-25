import os
import sys
import yaml
import re

#  Loading yaml file containing symbol rules
def load_config():
    script_directory = os.path.dirname(os.path.realpath(__file__))
    config_path      = os.path.join(script_directory, "symbols.yml")
    with open(config_path, "r") as config_file:
        config = yaml.safe_load(config_file)

    return config.get("categories", [])

# Checking the spaces between the symbols
def check_spacing(file_path, categories):
    errors = []

    with open(file_path, "r") as file:
        content = file.read()

    for category_info in categories:
        category_name = category_info.get("name")
        symbols       = category_info.get("symbols", [])

    for i, line in enumerate(content.splitlines(), start=1):
        if category_name and symbols:
            for symbol in symbols:
                if symbol in line:
                    # Check spacing before the symbol
                    if category_name == "single_before" and f" {symbol}" not in line:
                        errors.append((os.path.basename(file_path), i, f"Missing single space before '{symbol}'"))
                    # Check spacing after the symbol
                    elif category_name == "single_after" and f"{symbol} " not in line:
                        errors.append((os.path.basename(file_path), i, f"Missing single space after '{symbol}'"))
                    # Check spacing between
                    elif category_name == "double" and f"  {symbol}" not in line:
                        errors.append((os.path.basename(file_path), i, f"Missing double space around '{symbol}'"))
        if "input" in line and "//" not in line and not input_correct(line):
            errors.append((os.path.basename(file_path), i, f"Missing _i on input signal"))
        if "output" in line and "//" not in line and not output_correct(line) :
            errors.append((os.path.basename(file_path), i, f"Missing _o on output signal"))
    return errors

def input_correct(line):
    pattern = r'(\s+|)input\s+logic(\s+|)(\[.*\]|)\s+\w+_i.*'
    if "clk" not in line and "reset_n" not in line :
        match = re.match(pattern, line)
        return bool(match)
    else :
        return True

def output_correct(line):
    pattern = r'(\s+|)output\s+logic(\s+|)(\[.*\]|)\s+\w+_o.*'
    match = re.match(pattern, line)
    return bool(match)


# Applying the error check on all the files
def process_files(directory, extensions, categories):
    errors = []

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(tuple(extensions)):
                file_path = os.path.join(root, file)
                file_errors = check_spacing(file_path, categories)
                errors.extend(file_errors)

    return errors

# Printing the errors found
def print_and_write_errors(errors, output_file):
    # Sort errors by file and line number
    sorted_errors = sorted(errors, key=lambda x: x[0])

    with open(output_file, "w") as file:
        current_file = None
        for error in sorted_errors:
            file_name, line_number, message = error

            # Separate each file with a line in the report
            if file_name != current_file:
                file.write(f"----------------------\n{file_name}\n----------------------\n")
                current_file = file_name

            print(f"{file_name}, Line {line_number}: {message}")
            file.write(f"Line {line_number}: {message}\n")

if __name__ == "__main__":
    categories = load_config()

    if not categories:
        print("Error: No categories defined in the configuration file.")
        sys.exit(1)

    directory = "../../../src"  # Update the directory as needed
    extensions = [".sv"]
    output_file = "spacing_errors.txt"  # Update the output file name as needed

    errors = process_files(directory, extensions, categories)

    if errors:
        print_and_write_errors(errors, output_file)
        sys.exit(1)
    else:
        print(f"Spacing check passed for all symbols in '{directory}'")
