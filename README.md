# UI-Automation
This repo has code for automation of Bright Horizon webpages
## Project architecture
  * **UI Automated Tests**
    * **bin** : Test Suites which contains all test cases
    * **etc**
        * **keywords** : Robotframework keywords files pagewise used by the test cases 
        * **library** : Python librairies and robot file used to import all installed librairies
		    * **Page_Object** : Locators pagewise      


## Local Installation

**Prerequisites**  
For windows:  
Install Python 3.10 or higher

**Python Libraries Installation**  
`pip3 install --upgrade pip`  
`pip3 install -r pip-requirements.txt` 

## Execution
Tests can be executed through Visual Studio or through command line using below command:
`robot --test <testname>`



