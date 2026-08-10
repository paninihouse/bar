# Patches

Extend the program with additional functionality.

A *patch* is a set of source code changes that add a specific feature to a program.
Unlike plugins or extensions, patches modify the program directly — you edit the source, rebuild, and the new functionality becomes part of the binary.

The patch system is heavily inspired by the [*suckless* tools](https://suckless.org/hacking/) community, where this is the primary way to share and distribute enhancements.
Patches keep the core of *bar* minimal and focused, while allowing anyone to extend it with exactly what they need.

> Tip: Just like suckless, we encourage you to create and share your own patches with the community.

## How patches work

A patch is distributed as a `.patch` file and applied with the `patch` command.
The file contains a diff of the changes needed to add a specific feature.

For example, to apply a patch from the *bar* collection:

```shell
curl -sL https://raw.githubusercontent.com/paninihouse/bar/refs/heads/master/patches/bar-font_offset-20260810-11d813c.patch | patch -p1
```

After applying the patch, rebuild the program:

```shell
make install
```

> Important: If a patch does not apply cleanly (e.g., because your local code has diverged), you can either apply it manually by editing the source files by hand, or revert your changes with `git checkout .` and start from a clean copy.

## How to make a patch

Creating a patch is straightforward if you already made the changes in your local copy:

1. Make sure your working directory is a git repository.
2. Stage all the changes you want to include in the patch.
3. Run `git diff` to generate the patch file.

For example:

```shell
git diff > my-awesome-feature.patch
```

If you want to submit the patch to the community, upload it somewhere publicly accessible (e.g., a GitHub repo or a personal website) and link it in the patch documentation.

> Important: A good patch is focused on a single feature and does not include unrelated changes.
> This makes it easier for others to review and apply only what they need.

### Building upon other patches

Patches can depend on other patches.
If your feature requires a change that is already covered by an existing patch, simply list it as a prerequisite.

For example, a patch that adds a new styling option might depend on the <doc:patch-font-offset> patch because it touches the same area of the codebase.
When publishing, make sure to clearly document which patches (if any) must be applied first.

This modular approach lets the community mix and match features without duplicating work.

## Naming and publishing

When publishing a patch, use a descriptive file name that follows the convention:

```
bar-<feature_name>-<date>-<commit>.patch
```

For example:

```
bar-font_offset-20260810-11d813c.patch
```

The date pinpoints which version of the code the patch was made against, and the commit hash makes it easy to look up the exact state of the repository at that point.

To publish, upload the patch somewhere publicly accessible (e.g., the *bar* GitHub repo, a personal website, or a gist) and add a new article in the <doc:patches> documentation with:

- A short description of what the patch does.
- Any configuration options it adds.
- The installation instructions or a download link to the raw `.patch` file.
- The author(s).

> Tip: Keep the patch documentation in sync with the actual patch file. If you update the code, regenerate the patch and update the date and commit hash in both the file name and the documentation.

## Topics

### Appearance

- <doc:patch-font-offset>

### Functionality

- <doc:patch-screen-hotplug>
