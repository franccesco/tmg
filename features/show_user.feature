Feature: User
    It displays a list of a user's gem

    Scenario: Call tmg to get a list of a user's gems
        When I run `tmg user tenderlove`
        Then the output should contain "NOKOGIRI"

    Scenario: Call tmg to get a list of a user's gems and dependencies
        When I run `tmg user tenderlove -d`
        Then the output should contain "Dependencies"
