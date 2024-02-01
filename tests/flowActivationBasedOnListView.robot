*** Settings ***
Resource                 ../resources/common.robot
Suite Setup              Setup Browser
Suite Teardown           End suite
Test Template            Activate Flow

*** Test Case ***
Populate List Variable
Activate Flow with ${flowLabelList}


*** Keywords ***
Populate List Variable
    # do a bunch of stuff to render the table
Activate Flow
    # performs the actions on the table using the values populated in the list from the previous test
