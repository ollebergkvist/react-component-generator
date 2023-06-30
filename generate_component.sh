#!/bin/bash

valid_component_types=("layout" "component" "template")

# Function to display usage instructions
print_help() {
    valid_types_formatted=""
    for ((i=0; i<${#valid_component_types[@]}; i++)); do
        valid_types_formatted+="${valid_component_types[$i]}"
        if [ $i -lt $((${#valid_component_types[@]}-1)) ]; then
            valid_types_formatted+=", "
        fi
    done

    echo "Usage: ./create_component.sh <component_type> <component_name>"
    echo "  component_type: '$valid_types_formatted'"
    echo "  component_name: name of the component"
}

# Function to capitalize the first letter of a string
capitalize() {
    local string="$1"
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${string:0:1})${string:1}"
}

# Function to print a message in green color
print_green() {
    echo -e "\033[0;32m$1\033[0m"
}

# Function to print a message in red color
print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

# Check if component type is valid
is_valid_component_type() {
    local component_type="$1"
    for valid_type in "${valid_component_types[@]}"; do
        if [ "$component_type" = "$valid_type" ]; then
            return 0  # valid
        fi
    done
    return 1  # invalid
}

# Exit if --help or -h option is provided
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    print_help
    exit 0
fi

# Exit if component type is not provided
if [ -z "$1" ]; then
    print_red "Error: No component type provided."
    echo -e "\n"
    print_help
    exit 1
fi

# Exit if component type is not valid
if ! is_valid_component_type "$1"; then
    print_red "Error: Invalid component type."
    component_types_formatted=""
    for ((i=0; i<${#valid_component_types[@]}; i++)); do
        component_types_formatted+="${valid_component_types[$i]}"
        if [ $i -lt $((${#valid_component_types[@]}-1)) ]; then
            component_types_formatted+=", "
        fi
    done
    echo -e "Expected: $(print_green "$component_types_formatted"). Received: $(print_red "$1")"
    echo -e "\n"
    print_help
    exit 1
fi

component_type="$1"
component_name="$2"
component_type_directory="${component_type}s"
formatted_component_name="$(capitalize "$component_name")"
component_directory="src/$component_type_directory/$(capitalize "$component_name")"

# Exit if no component name is provided
if [ -z "$component_name" ]; then
    print_red "Error: No component name provided."
    echo -e "\n"
    print_help
    exit 1
fi

# Create component directory
if [ -d "$component_directory" ]; then
    print_red "Component already exists."
    exit 1
fi
mkdir -p "$component_directory"

# Generate TypeScript component file
component_file="$component_directory/$formatted_component_name.tsx"
cat > "$component_file" << EOF
// types
export interface ${formatted_component_name}Props {
  label: string;
}

export const ${formatted_component_name} = ({ label }: ${formatted_component_name}Props): JSX.Element => {
  return (
    <div>
      <h1>{label}</h1>
    </div>
  );
};
EOF

# Generate Storybook file
storybook_file="$component_directory/$formatted_component_name.stories.tsx"
cat > "$storybook_file" << EOF
// component
import { ${formatted_component_name} } from './${formatted_component_name}';

// types
import type { ComponentMeta } from '@storybook/react';
import type { ${formatted_component_name}Props } from './${formatted_component_name}';

export default {
  title: '${component_type_directory}/${component_name_directory}',
  component: ${formatted_component_name},
} as ComponentMeta<typeof ${formatted_component_name}>;

export const Default = (args: ${formatted_component_name}Props) => <${formatted_component_name} {...args} />;
EOF

# Generate test file
test_file="$component_directory/$formatted_component_name.test.tsx"
cat > "$test_file" << EOF
// libs
import { render } from '@testing-library/react';

// component
import { ${formatted_component_name} } from './${formatted_component_name}';

describe('${formatted_component_name}', () => {
  it('renders successfully', () => {
    expect(() => {
      render(<${formatted_component_name} label="Test Label" />);
    }).not.toThrow();
  });
});
EOF

# Generate index.ts barrel file
barrel_file="$component_directory/index.ts"
echo "export * from './${formatted_component_name}';" > "$barrel_file"

# Print overall success message with green icon
print_green "✔ Generating component files..."
echo -e "  $(print_green "✔") Successfully wrote file '$component_file'"
echo -e "  $(print_green "✔") Successfully wrote file '$storybook_file'"
echo -e "  $(print_green "✔") Successfully wrote file '$test_file'"
echo -e "  $(print_green "✔") Successfully wrote file '$barrel_file'"
