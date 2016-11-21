# dotfiles


## dotsync.sh

This script do the following:

1. Update your current local dotfiles repo with latest remote changes.

2. Scan this repo and subfolders for every file and folder starting with a dot.
   Only the root and the first level of subfolder are scanned.

3. Propose to the user the following list of changes:
  - Create symlinks from your home directory to the files from step 2.
  - Backup any file in your home repository that may be overwritten by the symlink creation.
  - Remove old symlinks from your home directory to missing file from this repo.
  
  This preview include the name of every files involved and the action that will be taken.
  
  It will also report: 
    - Rejected file from potential conflict when two files having the same name from different directory.
    - Ignored file when a file name is listed in the .dotignore file
    - Skipped file when a file is already symlinked to this repo.

4. If user confirm to proceed with the changes proposal:
  - apply them all at once.
  - create a symlink to the dotrevert.sh script

### options    
    sh dotsync.sh [-f] [-t filename] 

    -f    don't ask for user confirmation before applying changes.
    
    -t    only apply to the specified filename.




   

