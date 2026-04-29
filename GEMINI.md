Storazzo is a gem for managing:
1. external hard drives and their metadata.
2. local folders and their metadata.
3. google cloud storage buckets and their metadata.

It allows you to:
1. Scan a drive/folder and create a stats file.
2. Sync a drive/folder to GCS.
3. Search for a keyword across all indexed drives/folders.

The ultimate feature is, wherever you ware, you can answer the question: "Where is that file/folder X?"

## Dos and don'ts

* `Gemfile.lock` should be ignored: this is a gem, not an application, it should be updatable by the user.
* When committing, ensure to change VERSION and CHANGELOG.md for any non trivial changes. Also use `just deploy` after git push, after approval from user.