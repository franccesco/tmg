Feature: Version
    It displays the versions of the gems

    Scenario: Call tmg to get a list gems version
        When I run `tmg version rails`
        Then the output should contain "✔ rails →"
