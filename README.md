# @eliperkins' Advent of Code 2019 Solutions

I'm working through my Advent of Code 2019 solutions in Swift again this year!

I'm not sold on my project hierarchy yet, but in general, here it is:
- `AOCKit.framework`: A shared framework for the eventual functions that I'll want to share between days and solutions.
- `Day{N}.framework`: A framework per-day with the functions needed for the solution and a test target to work through test cases and build an answer
- `AllTests.xctestplan`: An Xcode test plan for executing all tests on CI to make sure nothing broke