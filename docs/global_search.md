---
layout: page
title: Global Search
permalink: /docs/global_search/
---

## Create ID for global search

In exVim, the global search use id-utils as the global search engine. Since the id-utils use a pre-generate index database for searching, it will be more efficient than grep/vimgrep.  You need to generate the database file --- ID first, you can use `:Up[date]` command.  The command will create all files need for exVim, if you just want to create ID, try `:Up[date]` ID commands.

## Search text

The global search provide two main method for search a word. The first one is using the `<leader>gg` operation, which will search the word under the cursor. The second one is `:GS <word>` which will search the `<word>` that user input.

When you are in global search select-window, you can press `<enter>` to jump to the result, meanwhile the exGlobalSearch will record the position to the [exJumpStack](../ex_jump_stack), you can use `<leader>tt` to check your stack result. And use `<leader>tf`, `<leader>tb` to move backward and forward from the next/last result.

## Concept

Basically when you get some result from global search plugin, it will list in select/quickview.  For instance, you global search 'TList' in a cpp project, and the result will like the picture below:

![global_search_sections.png](../images/global_search_sections.png)

As the picture show, we define some term for the item in the window. The concept is separate the result as file-section and preview-section so that we can apply filter in different sections.

## Using the filter

Based on the concept we discussed above, when you get the search result, you can apply filter to them to filter out the unwanted lines. To do this, you need to first apply a search pattern by use / or # and confirm the search. After that, you have several choice for filter:

***Useful Operations***

- `<leader>r`: Pick up results in {preview-section} matched the pattern you gived, and list them in quickview-window.
- `<leader>d`: Pick up results in {preview-section} unmatched patterns you gived, and list them in quickview-window.
- `<leader>fr`: Pick up results in {file-section} matched the pattern you gived, and list them in quickview-window.
- `<leader>fd`: Pick up results in {file-section} unmatched patterns you gived, and list them in quickview-window.
- `<leader>gr`: Pick up results in all sections matched the pattern you gived, and list them in quickview-window.
- `<leader>gd`: Pick up results in all sections unmatched patterns you gived, and list them in quickview-window.

You can use the filter again and again to get the exact result, that's the way we encourage people to do for search.

## tips, tricks, issues and settings

In chapter [Tips And Tricks](../tips_and_tricks), the Tip 1, 5, 6 shows how to some tips in using
global search.

The Issues 3, 5 in chapter [Known Issues](../known_issues) show the limitation for exGlobalSearch.

The [exGlobalSearch](../ex_global_search) chapter shows the detail settings of exGlobalSearch.
