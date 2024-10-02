
`git submodule add [url] [path]`  creates `.gitmodules` file, adds submodule directory.  Creates changes that can be committed.

run `git status`, see `.gitmodule`, the submodule directory, ready to be committed

- `git diff --cached [submodule name]` 
- `git diff --cached --submodule`



remember to commit and push.

# cloning a project with a submodule

`git submodule init` moves the `.gitmodules` into the other config files within `.git`

`git submodule update` gets all the git info with in the submodule, checks out the commit listed.

or could just to `git clone --recurse-submodules`

`git submodule update --init` does the same thing

`git submodule update --init --recursive` goets nested submodules.
glone it but then you 


# working on project with submodule

`git fetch` and `git merge origin/master`, or `git pull`

Can also go `git submodule update --remote [submodule name]`

can do `git diff --submodule` or globally go `git config --global diff.submodule log` to avoid `--submodule`.

Can then commit to in main project to permanenty set these changes.


By default `submodule update --remote` pulls fromt he remote's `HEAD`, the default branch, but  we can instead get set it to a different branch.

```
git config -f .gitmodule submodule.[sugmodule name].branch stable
```

`-f` makes it apply to everyone.

```
`git config --global status.submodulesummary 1`
```


# getting updates

`git pull` from main repo doesn't update the submodule.  Have to do `git submodule update`  . Best to do `git submodule --init --recursive` to be safe.


or do `git pull --recurse-submodules`.  Can make this automatic 


or `git config --global submodule.recurse true`


## if url has changed upstreadm

```
git submodule --sync --recursive
```




##
