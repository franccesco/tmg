Feature: Dependencies
    Show runtime and development dependencies,
    and no dependencies if it doesn't have.

    Scenario: Call tmg to get a gem info of only dev dependencies
        When I run `tmg i bundler -d`
        Then the output should contain "Development dependencies"

    Scenario: Call tmg to get a gem info of only runtime dependencies
        When I run `tmg i rails -d`
        Then the output should contain "Runtime dependencies"

    Scenario: Call tmg to get a gem info with no dependencies
        When I run `tmg i a -d`
        Then the output should contain "No dependencies"
