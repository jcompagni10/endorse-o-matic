# Endorse-O-Matic
Welcome to the Endorse-O-Matic a tool to simplify the LinkedIn endorsing proccess. It allows users to specify a batch of users whose skills they would like to endorse. The end user can quickly make those endorsements without having to spend tedious time clicking through individual profiles of their colleagues. EOM uses the selenium-webdriver to simulate real interaction with linkedin.
## Usage
1. clone this repository
2. bundle
3. run ``ruby lib/linked.rb`` (or ``ruby lib/linked.rb -f`` to use firefox instead of chrome) (Linux users: Chromium will probably work just fine.)
4. The program will prompt you for your LinkedIn credentials (don't worry nothing is saved)
5. You will be prompted whether you would like to send connect invites to users you are not yet connected with
6. Sit back and enjoy as the EOM goes to work!

If you are getting errors make sure you have installed the latest version of chrome.

If you are on a slow internet connection you may have to adjust the timeout interval on line 81
