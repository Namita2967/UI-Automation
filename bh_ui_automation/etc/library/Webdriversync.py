from selenium import webdriver
import logging
import os
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager

def get_chromedriver_path(show_wdm_logs=False):
    # if	not show_wdm_logs:
    driver_path = ChromeDriverManager().install()
    folder = os.path.dirname(driver_path)
    driver_path = os.path.join(folder, "chromedriver.exe")
    # else:
    # 	driver_path = ChromeDriverManager().install()
    print(driver_path)
    return  driver_path 
    
    
def get_gekodriver_path(show_wdm_logs=False):
	#   glpat-sGote4AnxuKB1qfz1SaF
    os.environ['GH_TOKEN'] = "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"
    if	not show_wdm_logs:
    	driver_path = GeckoDriverManager().install()
    else:
    	driver_path = GeckoDriverManager().install()
    print(driver_path)
    return  driver_path