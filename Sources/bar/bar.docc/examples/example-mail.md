# Unread emails

A script that prints the number of unread emails.

```shell
#!/bin/zsh

# Maildir roots to check for unread mail
maildirs=(
	"$HOME/.local/share/email/first-email@example.com"
	"$HOME/.local/share/email/second-email@example.com"
	"$HOME/.local/share/email/third-email@example.com"
)

# Count unread messages (files under */new/ at depth 2)
#
# Drop the -mindepth/-maxdepth constraints to recurse
# into nested mailboxes.
total_unread=0
for maildir in "${maildirs[@]}"; do
	total_unread=$(( total_unread + $(find "$maildir" -mindepth 3 -maxdepth 3 -type f -path "*/new/*" 2>/dev/null | wc -l) ))
done

# Conditionally display the block based on unread messages
(( total_unread > 0 )) && echo " 􀍖 $total_unread " || exit 0
```

> Note: This script is only useful if you're using a tool like [isync](https://isync.sourceforge.io/) to locally synchronise emails.
