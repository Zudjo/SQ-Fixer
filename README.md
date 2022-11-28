
# SQ-Fixer

### What is it?

SQ-Fixer is a tool for fixing some SonarQube issues automatically.

### Commands

##### delete

Deletes all **coded** comments.

##### var-to-let

Changes all **var** declarations in **let** declarations.

##### add-alt

Adds `alt=""` to all `<img>` and `<images>` tags that doesn't have it.

##### del-statics

Deletes all `html` and `map` files under `client\docs` or `client\dist`.

##### all

Executes all commands above at once.


## Disclaimer

This command will delete every commented code,
for each file of the specified extension
and under the specified directory and all its sub-directories.

Please note that UNDESIRED DELITIONS MAY HAPPEN,
therefore we suggest to run this command on a copy first
and check that everything works as expected before modifying distributions.
