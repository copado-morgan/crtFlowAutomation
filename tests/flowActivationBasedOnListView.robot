*** Settings ***
Resource                 ../resources/common.robot
Library                  QForce
Library                  QWeb
Library                  QVision
Library                  Collections
Suite Setup              Setup Browser
Suite Teardown           End suite

*** Test Cases ***
Collect and Activate Flows Listed in the flowsModifiedToday List View
    [Documentation]      Collects all values from the 'Flow Label' column in the table, stores them in a list variable. Intended to activate flows that were recently deployed.
    [Tags]               Table                       Collection                  Click           Error Handling
    Appstate             Setup
    TypeText             Quick Find                  flows
    ClickText            Flows
    Wait                 1
    QVision.ClickText    Flow Definitions            below=1
    Wait                 1
    ClickText            flowsModifiedToday
    VerifyNoText         Refresh this list to view the latest data
    @{flowLabel}         Create List
    Use Table            Flow API Name
    ${row_count} =       Get Table Row               //last
    FOR                  ${index}                    IN RANGE                    1               ${row_count}
        ${value} =       GetCellText                 r${index}c2
        Append To List                               ${flowLabel}                ${value}
    END
    FOR                  ${label}                    IN                          @{flowLabel}
        Activate Flow    ${label}
    END

