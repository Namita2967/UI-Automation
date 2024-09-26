*** Settings ***

Library    ../library/Webdriversync.py
Library    SeleniumLibrary
Library    String
Resource    ../Page_Object/UIObject.robot

*** Variables ***

${search_str}    New York
${URL}    https://www.brighthorizons.com/
${suburl}    /child-care-locator

*** Keywords ***

Login to BH homepage
    [Documentation]    This keyword is used to login to Bright Horizon home page with desired browser(Default browser is set as Firefox). 
    ...    User needs to pass desired browser Run time.
    [Arguments]    ${browser_name}=Chrome
    #Downloads the chrome and geko driver compatible to browser
    IF  '${browser_name}'=='Chrome'
        ${chromedriver_path}=    Get Chromedriver Path
        Create Webdriver    Chrome    executable_path=${chromedriver_path}
    ELSE IF    '${browser_name}'=='Firefox'
        ${gekodriver_path}=    Get Gekodriver Path
        Create Webdriver    Firefox    executable_path=${gekodriver_path}
    END    
    Go To    ${URL}
    Maximize Browser Window
    # Accepts Cookies
    Click Element    ${accept_cookies}
    # Wait till bright horizon logo is diplayed
    Wait Until Page Contains Element    ${bh_image}    timeout=20s    error=Page is taking more than 20s to load

Validate search center URL and functionality
    [Documentation]    This keyword is used to search a center under Find A Center link and match if count of search
    ...     result matches the no of centers shown. ALso the name and address shown in Map tool tip and search matches.  
    # Wait on page till 20s to see if Find a Center link is displayed. If time exceeds test fails  
    Wait Until Element Is Visible    ${find_center_element}    timeout=20s
    Click Element    ${find_center_element}
    # Returns the URL of current page 
    ${current_url}    Get Location
    #Validate if /child-care-locator is present in URL of current page
    Should Contain    ${current_url}    ${suburl}    error=The current page url doesnot contain ${suburl}
    #Send value to input search field
    Input Text    ${search_center_element}    ${search_str}
    #Send space to input search field after search value
    Press Keys   ${search_center_element}   SPACE
    #Used to press Enter 
    Press Keys   ${search_center_element}   RETURN
    #Checks if Page gives any result count
    ${Bool}    Run keyword and return Status    Wait Until Page Contains Element    ${center_results}    timeout=5s    error=The search result was not shown in 10s
    Capture Page Screenshot
    #If serach result is not seen it clears text and resend the text and click on Search
    IF  '${Bool}' == 'False'
        Clear Element Text    ${search_center_element}
        Input Text    ${search_center_element}    ${search_str}
        Press Keys   ${search_center_element}   SPACE   
        Press Keys   ${search_center_element}   RETURN
        Wait Until Page Contains Element    ${center_results}    timeout=10s    error=The search result was not shown in 10s.
        Capture Page Screenshot
    END
    ${Bool}    Run keyword and return Status    Get Text    ${center_results}
    #Returns the no of search results
    ${text}    Get Text    ${center_results}
    #Formats and remove a line from text
    ${text_new}    Replace String    ${text}    \n    ${SPACE}    
    Validate center Count
    Validate first center matches from Map mapTooltip

 Validate center Count
     [Documentation]  This keyword is used to match if count of search center result matches the no of centers shown below.
     ${result}    Get Text    ${center_results}
     #splits the Text of result count to fetch only number velue
     ${exp_result_count}    Split String    ${result}    separator= 
     #Retruns occurence of the locator
     ${actual_result_count}    Get Element Count    ${search_result}
     #compares both the nos
    Should Be Equal As Integers    ${actual_result_count}    ${exp_result_count}[0]    error= Mismatch in Result count and no of Centers shown on UI. Expected is ${exp_result_count} but got ${actual_result_count}

Validate first center matches from Map mapTooltip
    [Documentation]  This keyword is used to verify the name and address shown in Map tool tip and search matches.
    #Clicks first center link from search result 
    Click Element    ${first_center_result}
    #waits untile Map tool tip shows data for selected center. Fails if delays for 5 s
    Wait Until Element Is Visible    ${center_on_tooltip}    timeout=5s    error=Map tool tip doesnt show data for selected center.
    #Take the page screenshot for logging
    Capture Page Screenshot
    ${first_serach_name}    Get Text    ${first_center_result_name}
    ${first_search_tooltip_name}    Get Text    ${center_name_from_maptooltip}    
    Should Be Equal As Strings    ${first_search_tooltip_name}    ${first_serach_name}    error=Mismatch in Center name on Search result and Map tooltip
    ${first_serach_add}    Get Text    ${first_center_result_address}
    #Formats String
    ${add1}=    Replace String    ${first_serach_add}    \n    ${EMPTY}
    ${first_search_tooltip_add}    Get Text    ${center_address_from_maptooltip} 
    #Formats String
    ${add2}=    Replace String    ${first_search_tooltip_add}    \n    ${SPACE}
    Should Be Equal As Strings    ${add1}    ${add2}    error=Mismatch in Address on Search result and Map tooltip

Search from Homepage and validate results
    [Documentation]    This keyword is used to search a string from BH Homepage and search results shows the searched string at the top.
    [Arguments]    ${search_string}
    #Click on search icon on Homepage
    Click Element    ${search_icon}
    #Checks if Search input text area is available on Page
    Page Should Contain Element    ${search_input_text}    timeout=10s    Error=Search field is not visible on the page 
    #Typing Search string in Input 
    Input Text    ${search_input_text}    ${search_string}
    #Clicks Search button
    Click Element    ${search_button}
    Capture Page Screenshot
    ${text}    Get Text    ${search_title} 
    IF    '${text}' == 'No results found'
        Log To Console    There is no matching results for searched string ${search_string}
        Fail    msg=${search_title} not found on Page
    ELSE
    #Validation on match found
        Log To Console    There are matching results in Page for ${search_string}
        Wait Until Page Contains Element    ${search_string_result}    timeout=10s    error=There is no matching results for searched string ${search_string} 
        ${actual string}    Get Text    ${first_search_string}
        Should Be Equal As Strings    ${actual string}    ${search_string}    error=Expected string ${search_string} is not found in search result.     
    END
