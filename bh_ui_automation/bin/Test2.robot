*** Settings ***

Resource    ../etc/keywords/UI.robot

*** Test Cases ***

Test2
    [Tags]    Sanity    UI_Check
    [Documentation]    This test is designed to validate 'Find A Centers' link functonality on UI. 
    ...    When user try to find a center, the centers name and address should match with the values in Map tooltip.
    Login to BH homepage    browser_name=Chrome
    Validate search center URL and functionality
    #[Teardown]    Close All Browsers    (Close all browser is taken care by suite teardown defined in .init file) 