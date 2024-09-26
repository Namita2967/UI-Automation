*** Settings ***
Resource    ../etc/keywords/UI.robot

*** Variables ***
${url}    https://www.brighthorizons.com/  
${search_string}	Employee Education in 2018: Strategies to Watch  

*** Test Cases ***

Test1
    [Tags]    Regression    UI_check
    [Documentation]    This test is designed to validate Search functionality on Bright Horizon Homepage.
    Login to BH homepage    
    Search from Homepage and validate results    ${search_string}    
    [Teardown]    Close All Browsers
