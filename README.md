# Mount Sinai Cleaning Study

## Prerequisites

- **MATLAB**: Ensure you have MATLAB installed on your computer, as this script is specifically designed for MATLAB.
- **Data File**: Download and save the `data.xlsx` file containing the necessary joint angle data. The file should contain a sheet named `Joint Angles ZXY` with data in the specified format and range.

## Usage

### On Linux

1. **Open Terminal**: Navigate to the directory where your MATLAB script and `data.xlsx` file are located.
2. **Start MATLAB**: Type `matlab` in the terminal to open MATLAB. If MATLAB is installed correctly and included in your system's PATH, this command should start the MATLAB GUI.
3. **Run the Script**: In the MATLAB Command Window, navigate to the script's directory using the `cd` command (e.g., `cd /path/to/your/script`). Once in the correct directory, run the script by typing its name without the `.m` extension (e.g., `run data_analysis`).

### On Windows

1. **Open MATLAB**: Locate the MATLAB shortcut on your desktop or in your Start menu and open the program.
2. **Navigate to File**: Use the MATLAB Current Folder window to navigate to the folder where your `data.xlsx` and the MATLAB script are saved.
3. **Run the Script**: Double-click the script file to open it in the MATLAB Editor, then press the **Run** button in the toolbar or press `F5` on your keyboard to execute the script.

To run the MATLAB script without using the GUI (Graphical User Interface), commonly known as running it "headlessly," you can use the MATLAB command-line interface. This method is useful for executing scripts on remote servers, automated tasks, or environments where GUI usage is limited or not preferred. Below are the steps for running the script headlessly on both Linux and Windows systems.

## HEADLESS USAGE

### Headless Usage on Linux

1. **Open Terminal**: Navigate to the directory where your MATLAB script and `data.xlsx` file are stored.
2. **Execute MATLAB Script**: Use the following command to run your script without opening the MATLAB GUI:

   ```bash
   matlab -nodisplay -nosplash -nodesktop -r "run('data_analysis.m');exit;"
   ```

### Headless Usage on Windows

1. **Open Command Prompt**: Press `Win + R`, type `cmd`, and press Enter to open the Command Prompt.
2. **Navigate to Your Script's Directory**: Use the `cd` command to change to the directory containing your script and `data.xlsx`.
3. **Execute MATLAB Script**: Run the following command in the Command Prompt:

   ```cmd
   matlab -nodisplay -nosplash -nodesktop -r "run('data_analysis.m');exit;"
   ```

### Additional Notes

- Make sure the `data.xlsx` file is in the same directory as the MATLAB script or specify the correct path to the file in the script's `readtable` function.
- Ensure MATLAB's command-line executable is added to your system's PATH. This makes it possible to invoke MATLAB from the terminal (Linux) or Command Prompt (Windows) without specifying the full path to the MATLAB executable.