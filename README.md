Absolutely! I’ll expand the README to cover everything discussed in the whiteboard session, including the logic behind the design, the steps for testing, and details on README - USB Lab Builder

Project Overview

The USB Lab Builder is a comprehensive script designed for controlled testing of media enumeration, file parsing, and system behaviors related to USB devices. This tool automates the creation of a structured environment on a USB drive that will trigger a variety of scenarios on the target system (such as a car infotainment system or media player). By systematically manipulating the file structure and media files, you can observe how the system reacts under different conditions, like file renaming, corruption, and metadata manipulation.

This project includes:
	1.	Predefined File Structure: Automates the creation of a deterministic file structure on the USB drive.
	2.	Test Layers: Toggleable tests for stress testing, hidden files, image files, and corrupt media files.
	3.	MP3 Manipulation: Control and mutate MP3 files to see how the target system reacts.
	4.	Delta Scanner: Tracks changes in the USB structure after the system has indexed or interacted with the drive.

⸻

Key Features
	1.	Deterministic File Structure: Consistently sets up the same directory structure for repeatable experiments.
	2.	Flexible Test Layers: Control what tests to enable or disable (such as stress tests, corrupt file tests, or hidden files).
	3.	Controlled MP3 Mutations: Easily modify MP3 files to observe different behaviors (e.g., file renaming, metadata changes, etc.).
	4.	Delta Tracking: Tracks file changes using the delta scanner to monitor system responses during the tests.
	5.	Customizable Parameters: Tailor the test conditions by modifying the test layer flags in the script.

⸻

Project Design Philosophy

Core Design Principles:
	•	Modular and Layered Approach: The tests are separated into layers (i.e., different file manipulations, media, hidden files, etc.) that you can enable/disable based on the needs of your experiment.
	•	Manual Control of Key Variables: The MP3 file (02_test.mp3) is the key focus for testing, and you manually control modifications to it.
	•	Isolation of Changes: You isolate one change per test to see exactly how that variable affects the system, ensuring controlled experimentation.
	•	Consistent Environment: The file structure is deterministic, meaning it’s always the same each time you run the script, ensuring consistency across tests.

⸻

Project Setup

1. Prepare USB Drive
Make sure your USB drive is formatted properly (preferably FAT32 or exFAT) and is empty or ready to be used for testing. Ensure it’s mounted at a known location (e.g., /media/$USER/YOUR_USB_NAME).

2. Clone the Project
Clone or download the repository containing the usb_lab_builder.sh and file-delta-tracker-vs1.py scripts.

git clone https://your-repo-url.git
cd your-repo-directory

3. Make the Script Executable
Grant execute permissions to the usb_lab_builder.sh script:

chmod +x usb_lab_builder.sh

4. Run the Script to Build the USB Structure
Run the usb_lab_builder.sh script to automatically build the USB structure and populate it with files for testing. Replace YOUR_USB_NAME with the name of your USB drive.

./usb_lab_builder.sh /media/$USER/YOUR_USB_NAME

If you encounter permission errors, run the script with sudo:

sudo ./usb_lab_builder.sh /media/$USER/YOUR_USB_NAME


⸻

Script Breakdown

Core Structure (Always Built)
The following file and directory structure will always be created on the USB drive:

/MUSIC/Artist/Album/01_control.mp3
/MUSIC/Artist/Album/02_test.mp3
/PLAYLISTS/test.m3u
/PICTURES/image1.jpg
/PICTURES/large.jpg
/EXPERIMENT/nested/A/B/C/file.mp3
/random.mp3
/Thumbs.db
/.DS_Store
/LOGS/

Test Layers (Toggleable)
You can toggle the following layers by changing the flags in the script:
	1.	ENABLE_IMAGES: Adds test images to the USB drive to test how the target system handles media and images together.
	2.	ENABLE_CORRUPT: Adds a corrupt image file to test error handling.
	3.	ENABLE_STRESS: Adds a large number of small text files to stress test the system’s indexing and performance.
	4.	ENABLE_HIDDEN: Adds hidden files like .DS_Store and Thumbs.db to simulate OS-level artifacts.

Test Variables and Actions
	•	01_control.mp3: This file remains unchanged throughout testing and acts as the baseline for system behavior.
	•	02_test.mp3: This file is modified per test. You will rename, change metadata, and manipulate this file to track system responses.
	•	Playlists: The test.m3u playlist includes references to both the control file and test files, ensuring the system re-parses the media files during testing.

⸻

Testing Procedure
	1.	Insert USB Drive into the target system (such as a car infotainment system).
	2.	Allow the system to index the files on the USB. This may take some time depending on the file system, number of files, and directory depth.
	3.	Remove the USB and run the delta scanner (file-delta-tracker-vs1.py) to track changes made by the system during indexing.
	4.	Modify 02_test.mp3 for each test:
	•	Rename the file (e.g., 02_test_super_long_name.mp3).
	•	Modify metadata (e.g., album, artist name) using a tool like Mp3tag.
	•	Add album art using ffmpeg or similar tools.
	•	Remove or corrupt metadata to see if the system can handle missing or invalid data.
	5.	Repeat the tests, modifying one variable per iteration to isolate the effects of each change.
	6.	Use the delta scanner to track file changes, timestamp changes, and any new files created during the test.

⸻

Delta Scanner Usage

To track the changes on the USB drive after it has been indexed by the target system, use the file delta tracker:

python3 file-delta-tracker-vs1.py

The scanner will log:
	•	Added files (e.g., files that the system created during the indexing process).
	•	Removed files (e.g., files that the system deleted or ignored).
	•	Seen files (e.g., files that were read but not modified).
	•	It will save the log results to a file, providing a detailed comparison of the USB state before and after indexing.

⸻

Advanced Customization

MP3 Mutations
To test how different file variations affect system behavior, you can manually modify 02_test.mp3:
	•	Rename the file: Use long file names, special characters, or random strings.
	•	Modify metadata: Use Mp3tag or similar tools to change the album, artist, genre, or year.
	•	Change encoding: Convert the file to a different encoding format (e.g., MP3 -> AAC).
	•	Add album art: Use ffmpeg or other tools to inject album artwork into the file.

Test Layers
You can control which layers are applied during testing by adjusting the following flags in the script:
	•	ENABLE_IMAGES=1: Enables the addition of image files.
	•	ENABLE_CORRUPT=1: Adds corrupt files for error handling.
	•	ENABLE_STRESS=1: Adds a large number of files to stress-test indexing.
	•	ENABLE_HIDDEN=1: Adds hidden files to test filtering behavior.

⸻

File Structure

Here’s the complete layout of the USB after the script runs:

/MUSIC/Artist/Album/
  ├── 01_control.mp3
  ├── 02_test.mp3
/PLAYLISTS/
  └── test.m3u
/PICTURES/
  ├── image1.jpg
  └── large.jpg
/EXPERIMENT/
  └── nested/A/B/C/
      └── file.mp3
/random.mp3
/Thumbs.db
/.DS_Store
/LOGS/

File Structure Purpose
	•	/MUSIC: Contains music files that will be indexed by the target system.
	•	/PLAYLISTS: Includes the playlist that references the music files, ensuring the system parses them.
	•	/PICTURES: Adds image files to test how the system handles multiple media types.
	•	/EXPERIMENT: Includes deeply nested directories and files to test file system traversal.
	•	/random.mp3: A root-level media file to trigger root scan behaviors.
	•	/Thumbs.db, /.DS_Store: Simulates real-world OS artifacts that are typically hidden.
	•	/LOGS: A directory to store logs of the experiment for tracking purposes.

⸻

License

This project is licensed under the MIT License.

⸻

Conclusion

The USB Lab Builder is a powerful tool for conducting controlled, repeatable tests on USB drives, allowing you to observe how your target system handles file enumeration, media parsing, and indexing under various conditions. By modifying the MP3 files and other test files, you can track the system’s behavior and identify vulnerabilities or optimization opportunities.

Let me know if you need further adjustments to this README or additional information!
