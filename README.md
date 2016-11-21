# dotfiles


## dotsync.sh

Create symlinks to your dotfiles with the following steps:

1. Update your current local dotfiles repo with the latest remote changes.

2. Scan this repo and subfolders for every file and folder starting with a dot.
   Only the root and the first level of subfolder are scanned.

3. Propose to the user the following list of changes:
  - Create symlinks from your home directory to the files from step 2.
  - Backup any file in your home repository that may be overwritten by the symlink creation.
  - Remove old symlinks from your home directory to missing file of this repo.
  
  This preview include the name of every files involved and the action that will be taken.
  
  It will also report: 
    - Rejected file from potential conflict when two files have the same name from different directory.
    - Ignored file when a file name is listed in the .dotignore file
    - Skipped file when a file is already symlinked to this repo.

4. If user confirm to proceed with the changes proposal:
  - apply them all at once.
  - create a symlink to the dotrevert.sh script

## dotrevert.sh

Undo the dotsync.sh changes:

1. Scan the user home directory for any symlinks pointing to a file of this repo.
2. Scan the backup folder.
3. Propose to the user the following list of changes:
   - Remove all files from step 1 in the home directory.
   - Restore all files from step 2 in the home directory.
4. If user confirm to proceed with the changes proposal, apply them all at once.
   
#### options    
    sh dotsync.sh [-f] [-t filename] 
    sh dotrevert.sh [-f] [-t filename] 

    -f: don't ask for user confirmation before applying changes.
    -t: only apply to the specified filename.
   

