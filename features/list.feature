Feature: List
    It displays a list of my gems

    Scenario: Call tmg to get a list of my gems by default
        When I run `tmg`
        Then the output should contain "Info:"

    Scenario: Call tmg with list command to retrieve a list of your gems
        When I run `tmg list`
        Then the output should contain "Info:"

    Scenario: Call tmg with list command to retrieve a list of your gems
        When I run `tmg list -d`
        Then the output should contain "Dependencies"
