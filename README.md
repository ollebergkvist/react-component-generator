# Component Generator Script

This repository contains a bash script for generating component files in a specified directory structure. The script creates TypeScript component files, Storybook files, test files, and index.ts barrel files for easy module imports.

## Usage

To use the script, follow the instructions below:

1. Clone the repository:

   ```shell
   git clone https://github.com/ollebergkvist/component-generator-script.git
   ```

2. Navigate to the repository:

   Run the script:

   ```
   ./generate_component.sh <component_type> <component_name>
   Replace <component_type> with the type of the component (valid options: layout, component, template) and <component_name> with the desired name of the component.
   ```

   The script will generate the necessary component files in the appropriate directory.

   For example, to generate a component named "Button" of type "component", run the following command:

   ```
   ./generate_component.sh component Button
   ```

   This will generate the component files for the Button component:

   ```
   components/
   └─ Button/
      ├─ Button.tsx
      ├─ Button.stories.tsx
      ├─ Button.test.tsx
      └─ index.ts
   ```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.
