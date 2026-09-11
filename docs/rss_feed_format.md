# NativeTavern RSS Notification Feed Format

NativeTavern supports an in-app notification system that alerts users to important updates, announcements, or upcoming changes. The application fetches these updates from a remote RSS feed defined by the `RSS_FEED_URL` environment variable.

The app specifically expects an **Atom syndication format** feed (XML). When a user receives notifications, the app tracks which notifications have been viewed or dismissed locally using the entry's unique ID.

## Required Feed Structure

The feed must be standard Atom XML. Below is a breakdown of the specific XML elements the application parses:

### `feed` (Root Element)
The root element of the XML document.

### `entry` (Individual Notifications)
Each notification is wrapped in an `<entry>` block.

NativeTavern parses the following tags within each `<entry>`:

1. `<id>`: A unique identifier for the notification. This is crucial because it's used to remember if a user has already dismissed the notification. (If absent, the app falls back to `<link>` or `<title>`).
2. `<title>`: The headline of the notification. (Required. If missing or empty, the entry is ignored).
3. `<link href="...">`: A clickable URL that users can open for more details. (Optional but recommended).
4. `<updated>` or `<published>`: A standard ISO 8601 date string (e.g. `2026-09-15T08:00:00Z`). The app uses this to sort notifications from newest to oldest.
5. `<summary>` or `<content>`: The body text of the notification describing the update.

## Example Atom Feed

Here is an example `feed.xml` file that you can serve statically (e.g. via GitHub Pages, Netlify, Cloudflare Pages, etc.):

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>NativeTavern Updates</title>
  <link href="https://nativetavern.com/"/>
  <updated>2026-09-10T12:00:00Z</updated>
  <id>https://nativetavern.com/feed.xml</id>

  <!-- Example Notification 1 -->
  <entry>
    <id>nt-update-v1-5-0</id>
    <title>NativeTavern v1.5.0 Released!</title>
    <link href="https://github.com/miaoxworld/NativeTavern/releases/tag/v1.5.0"/>
    <updated>2026-09-10T12:00:00Z</updated>
    <summary>We just released v1.5.0 with support for new local models and custom system prompts. Update your app today!</summary>
  </entry>

  <!-- Example Notification 2 -->
  <entry>
    <id>nt-community-discord-launch</id>
    <title>Join our official Discord Server</title>
    <link href="https://discord.gg/URQvW2FvZa"/>
    <published>2026-09-01T09:30:00Z</published>
    <content>Come chat with developers, share character cards, and get support in our new Discord community.</content>
  </entry>

</feed>
```

## Configuring the App Environment

To connect the application to your feed during development or build time, simply provide the URL in your `.env` file:

```env
RSS_FEED_URL=https://nativetavern.com/feed.xml
```

When building via the standard scripts (e.g. `./build_android.sh`), this URL is injected securely and is ready to be fetched by the app upon launch.
