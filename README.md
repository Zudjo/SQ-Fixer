
# SQ-Fixer

## What is it?

SQ-Fixer is a tool for fixing some SonarQube issues automatically.

## Disclaimer

This script will modify pieces of code,
for each file of the specified extension
and under the specified directory and all its sub-directories.

Please note that UNDESIRED MODIFICATIONS MAY HAPPEN,
therefore we suggest to run this command on a copy first
and check that everything works as expected before modifying distributions.

## Commands

#### delete-commented-code

Deletes all **coded** comments.

`.\main.ps1 delete-commented-code <path> <extension,[extension],[extension]...>`
`.\main.ps1 delete-commented-code <path> <'all'>`

#### change-vars-to-lets

Changes all **var** declarations in **let** declarations.

`.\main.ps1 change-vars-to-lets <path>`

#### add-alt-attributes

Adds `alt=""` to all `<img>` and `<images>` tags that doesn't have it.

`.\main.ps1 add-alt-attributes <path>`

#### delete-client-statics

Deletes all `html` and `map` files under `client\docs` or `client\dist`.

`.\main.ps1 delete-client-statics <path>`

#### all

Executes all commands above at once.

`.\main.ps1 all <path> <extension,[extension],[extension]...>`
`.\main.ps1 all <path> <'all'>`
