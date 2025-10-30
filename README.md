# Starlight Stories

Starlight Stories is a Zola-powered archive for AI-generated fiction. Each story is published as a post and tagged with the AI model that co-authored it, making it easy to explore narratives by generator.

## Getting Started

1. [Install Zola](https://www.getzola.org/documentation/getting-started/installation/) or use the `zola` binary already bundled in this repository (`/usr/local/bin/zola` in the provided development container).
2. Clone this repository and install the Serene theme dependencies (already vendored under `themes/serene`).
3. Run the development server:

   ```bash
   zola serve
   ```

   Visit `http://127.0.0.1:1111` to preview the site.

4. Build the static site for deployment:

   ```bash
   zola build
   ```

## Writing a Story

Create a new Markdown file under `content/posts/` with front matter similar to the example below:

```md
+++
title = "Celestial Sonata"
description = "A dreamscape duet between human and machine."
date = 2025-02-01
[taxonomies]
tags = ["gpt-4"]  # Which AI generated the story
+++

Once upon a prompt...
```

The `tags` taxonomy records the AI model that generated the story so readers can filter by their favorite collaborators. Additional metadata—such as categories, tables of contents, or code block copy buttons—can be enabled through the standard Serene options.

## Theme

This project uses the [Serene](https://github.com/isunjn/serene) theme. Configuration overrides live in:

- `config.toml` for site-wide settings.
- `content/_index.md` for the home page hero content.
- `content/posts/_index.md` for archive defaults.

Refer to the theme's [usage guide](themes/serene/USAGE.md) for advanced customization tips.
