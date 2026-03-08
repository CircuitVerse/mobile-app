# Interactive Book API Restructure Specification

## Problem
The current API sends raw markdown content that the Flutter app must parse manually. This causes parsing issues like skipping headings, incorrect formatting, and complex maintenance.

## Solution
Send structured JSON from the API with pre-parsed content blocks, eliminating client-side markdown parsing.

## API Changes (Interactive-Book Project)

### New Endpoint Structure
Instead of returning `raw_content` as a string, return `structured_content` as an array of content blocks.

### Content Block Types

```json
{
  "type": "heading",
  "level": 1-6,
  "text": "Heading text",
  "id": "heading-slug"
}

{
  "type": "paragraph",
  "content": [
    {"type": "text", "value": "Plain text"},
    {"type": "bold", "value": "Bold text"},
    {"type": "italic", "value": "Italic text"},
    {"type": "code", "value": "inline code"},
    {"type": "link", "text": "Link text", "url": "https://..."}
  ]
}

{
  "type": "list",
  "ordered": false,
  "items": [
    {
      "content": [{"type": "text", "value": "Item 1"}],
      "items": [] // nested items
    }
  ]
}

{
  "type": "code_block",
  "language": "javascript",
  "code": "const x = 1;"
}

{
  "type": "blockquote",
  "content": [{"type": "text", "value": "Quote text"}]
}

{
  "type": "table",
  "headers": ["Col 1", "Col 2"],
  "rows": [
    ["Cell 1", "Cell 2"]
  ]
}

{
  "type": "quiz",
  "questions": [
    {
      "question": "Question text",
      "answers": [
        {"text": "Answer 1", "correct": true},
        {"text": "Answer 2", "correct": false}
      ]
    }
  ]
}

{
  "type": "binary_simulator"
}

{
  "type": "horizontal_rule"
}
```

### Example API Response

```json
{
  "path": "docs/binary.md",
  "title": "Binary Numbers",
  "http_url": "https://...",
  "structured_content": [
    {
      "type": "heading",
      "level": 1,
      "text": "Binary Numbers",
      "id": "binary-numbers"
    },
    {
      "type": "paragraph",
      "content": [
        {"type": "text", "value": "Binary is a "},
        {"type": "bold", "value": "base-2"},
        {"type": "text", "value": " number system."}
      ]
    },
    {
      "type": "code_block",
      "language": "python",
      "code": "binary = 0b1010"
    }
  ],
  "table_of_contents": [...],
  "has_children": false,
  "has_toc": true
}
```

## Flutter App Changes (mobile-app Project)

### New Models
- `IbStructuredContent` - base class for all content types
- `IbHeading`, `IbParagraph`, `IbList`, `IbCodeBlock`, etc.
- `IbInlineContent` - for inline text formatting

### Updated Files
1. `lib/models/ib/ib_content.dart` - Add structured content models
2. `lib/models/ib/ib_raw_page_data.dart` - Add `structuredContent` field
3. `lib/services/ib_engine_service.dart` - Remove markdown parsing logic
4. `lib/ui/views/new_ib/components/new_ib_home_page.dart` - Use structured renderer
5. Create `lib/ui/views/new_ib/components/structured_content_renderer.dart`
6. Remove `lib/ui/views/new_ib/components/new_ib_markdown_parser.dart`

### Migration Strategy
1. Keep both `raw_content` and `structured_content` in API during transition
2. Flutter app checks for `structured_content` first, falls back to `raw_content`
3. Once all content is migrated, remove `raw_content` support

## Implementation Steps

### Phase 1: API (Interactive-Book)
1. Create markdown parser that outputs structured JSON
2. Add `structured_content` field to API responses
3. Keep `raw_content` for backward compatibility
4. Test with sample pages

### Phase 2: Flutter App (mobile-app)
1. Create structured content models
2. Create structured content renderer
3. Update API service to handle both formats
4. Test with new API
5. Remove old markdown parser once stable

## Benefits
- No client-side markdown parsing
- Consistent rendering across platforms
- Easier to maintain and extend
- Better error handling
- Faster rendering (no parsing overhead)
- Type-safe content structure
