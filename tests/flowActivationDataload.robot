*** Settings ***
Resource                 ../resources/common.robot
Library                  DataDriver                  reader_class=TestDataApi    name=flowActivation.xlsx
Suite Setup              Setup Browser
Suite Teardown           End suite
Test Template            Activate Flow


*** Test Case ***
Activate Flow with ${flowLabel}

*** Keywords ***
 Activate Flow
    [Arguments]          ${flowLabel}
    Setup
    Log                  ${flowLabel}                #uncomment for troubleshooting variable value
    TypeText             Quick Find                  flows
    ClickText            Flows
    QVision.ClickText    Flow Definitions            below=1
    ClickText            flowsModifiedToday
    VerifyNoText         Refresh this list to view the latest data
    UseTable             SortFlow API NameSorted AscendingColumn Actions
    Wait                 1
    ClickCell            r?${flowLabel}/c11
    ClickText            View Details and Versions
    Wait                 2                           #seems to be a lag in rendering the table. Open to other ways to fix this
    ClickText            Activate                    ${flowLabel}

