# Jose Rocha's Theme for Oh-My-Zsh

Enhance your terminal experience with the Jose Rocha Theme for Oh-My-Zsh, designed to provide a visually
appealing and functional command line interface. This theme integrates dynamic project detection, displays
comprehensive environment information, and adapts its color scheme from the elegant Gogh-Co's Clone of Ubuntu.
Whether you're managing Python, Node.js, Java, or C# projects, this theme keeps you informed about your
development environment while offering a sleek interface.

## Features

- **Dynamic Project Detection**: Automatically identifies the type of project you are working in (Python,
  Node.js, Java, C#).
- **Enhanced Git Integration**: Displays detailed Git branch information including the status of changes
  directly in your prompt.
- **Adaptive Color Scheme**: Utilizes a rich color palette with support for both 256-color and 16-color
  terminals to enhance readability and aesthetics.
- **Environment Information**: Shows virtual environments, Conda environments, and other relevant settings to
  keep you informed about your workspace.

## Installation

To install the Jose Rocha Theme, follow these steps:

1. **Clone the repository** into your Oh-My-Zsh custom themes directory:

   ```sh
   git clone https://github.com/jrocha-dev/ohmyzsh-theme-jrocha.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/jrocha
   ```

2. **Set the theme** in your `.zshrc` file by updating the following line:

   ```sh
   ZSH_THEME="jrocha/jrocha"
   ```

3. **Apply the changes** by reloading your terminal configuration:

   ```sh
   source ~/.zshrc
   ```

## Customization

You can customize the color palette and other settings by editing the theme file directly in your themes
directory.

## Contributions

Contributions are welcome! If you have improvements or bug fixes, please fork the repository, make your
changes, and submit a pull request.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgments

- Guidance on creating Zsh themes from
  [Writing ZSH Themes: A Quickref](https://blog.carbonfive.com/writing-zsh-themes-a-quickref/).
- Inspiration from [Gogh-Co's Clone of Ubuntu](https://github.com/Gogh-Co/Gogh).
- Helpful resources from the [Oh My Zsh community](https://github.com/ohmyzsh/ohmyzsh).
