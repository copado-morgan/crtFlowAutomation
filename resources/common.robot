*** Settings ***
Library                   QForce
Library                   String
Library                   QVision
Library                   QWeb

*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                chrome
${username}               mschulz@copado.com.1-24.dev1
${login_url}              https://drive-site-2345--dev1.sandbox.lightning.force.com            # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}               ${login_url}/lightning/page/home
${setup_url}              ${login_url}/lightning/setup/SetupOneHome/home


*** Keywords ***
Setup Browser
    # Setting search order is not really needed here, but given as an example 
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order                          QForce    QWeb   QVision    String
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    Evaluate              random.seed()               random                 # initialize random generator
    SetConfig             DefaultTimeout              15s                    #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig             Delay                       0.3

End suite
    Close All Browsers


Login
    [Documentation]       Login to Salesforce instance
    GoTo                  ${login_url}
    TypeText              Username                    ${username}             delay=1
    TypeText              Password                    ${password}
    ClickText             Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=       Run Keyword And Return Status          Should Not Be Equal    ${None}       ${secret}
    Run Keyword If       ${MFA_needed}               Fill MFA


Login As
    [Documentation]       Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                   before calling this keyword to change persona.
    ...                   Example:
    ...                   LoginAs    Chatter Expert
    [Arguments]           ${persona}
    ClickText             Setup
    ClickText             Setup for current app
    SwitchWindow          NEW
    TypeText              Search Setup                ${persona}             delay=2
    ClickElement          //*[@title\="${persona}"]   delay=2    # wait for list to populate, then click
    VerifyText            Freeze                      timeout=45                        # this is slow, needs longer timeout          
    ClickText             Login                       anchor=Freeze          delay=1      

Fill MFA
    ${mfa_code}=         GetOTP    ${username}   ${secret}   ${login_url}    
    TypeSecret           Verification Code       ${mfa_code}      
    ClickText            Verify 


Home
    [Documentation]       Navigate to homepage, login if needed
    GoTo                  ${home_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce

Setup
    [Documentation]       Navigate to setup
    GoTo                  ${setup_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    GoTo                  ${setup_url}                #it's stupid, but it works.
    VerifyText    Setup Home


# Example of custom keyword with robot fw syntax
VerifyStage
    [Documentation]       Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]           ${text}                     ${selected}=true
    VerifyElement        //a[@title\="${text}" and (@aria-checked\="${selected}" or @aria-selected\="${selected}")]


NoData
    VerifyNoText          ${data}                     timeout=3                        delay=2


DeleteAccounts
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Delete
    VerifyText            Are you sure you want to delete this account?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Accounts                    partial_match=False


DeleteLeads
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Delete
    VerifyText            Are you sure you want to delete this lead?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Leads                    partial_match=False

Activate Flow
    [Documentation]    Used on a list view of flows. Activates a flow with the name ${label}, then returns to the flowsModifiedToday list view
    [Arguments]          ${label}
    UseTable             SortFlow API Name
    Wait                 2
    ClickCell            r?${label}/c11
    ClickText            View Details and Versions
    Wait                 2                           #seems to be a lag in rendering the version table. Open to other ways to fix this
    ClickText            Activate                    ${label}
    Wait                 3                        #usually a delay after activating the flow
    ClickText            Back to List: Flows
    QVision.ClickText    Flow Definitions            below=1
    ClickText            flowsModifiedToday
    VerifyNoText         Refresh this list to view the latest data
