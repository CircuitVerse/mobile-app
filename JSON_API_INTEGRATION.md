# JSON API Integration for Interactive Book

This document describes the JSON-based API integration for the Interactive Book mobile app.

## Overview

The mobile app now supports fetching structured JSON content from the backend API instead of parsing Markdown. This provides better performance, type safety, and easier maintenance.

## API Endpoints

### Base URL
- Development: `http://localhost:4000/api-mobile/pages`
- Production: Configure via `IB_JSON_API_BASE_URL` environment variable

### Endpoint Format
```
GET /api-mobile/pages/{path}.json
```

### Examples
- Index page: `/api-mobile/pages/docs/binary-representation/index.json`
- Chapter page: `/api-mobile/pages/docs/binary-representation/binary-numbers.json`

## JSON Structure

### Page Data
```json
{
  "id": "binary-numbers",
  "title": "Binary Numbers",
  "description": "Optional description",
  "nav_order": "l0s000",
  "level": "basic",
  "parent": "Binary representation",
  "has_children": false,
  "path": "docs/binary-representation/binary-numbers",
  "metadata": {},
  "content": {
    "sections": []
  },
  "children": [],
  "key_concepts": [],
  "related_topics": []
}
```

### Content Sections

#### Heading
```json
{
  "type": "heading",
  "level": 1,
  "text": "Binary Numbers",
  "id": "binary-numbers"
}
```

#### Paragraph
```json
{
  "type": "paragraph",
  "text": "Binary number system was invented by Gottfried Leibniz..."
}
```

#### Section
```json
{
  "type": "section",
  "heading": {
    "level": 2,
    "text": "Introduction",
    "id": "introduction"
  },
  "content": [
    {
      "type": "paragraph",
      "text": "..."
    }
  ]
}
```

#### Subsection with Tables
```json
{
  "type": "subsection",
  "heading": "How Binary Counting Works",
  "tables": [
    {
      "title": "Binary Counting Basics",
      "headers": ["Binary", "Explanation"],
      "rows": [
        ["0", "Start at 0"],
        ["1", "Then 1"]
      ]
    }
  ]
}
```

#### Example
```json
{
  "type": "example",
  "title": "Decimal to Binary Example",
  "data": {
    "decimal": 25,
    "binary": "11001"
  }
}
```

#### Steps
```json
{
  "type": "steps",
  "title": "Conversion Steps",
  "steps": [
    {
      "step": 1,
      "description": "Write the decimal value..."
    }
  ],
  "note": "Optional note"
}
```

#### Widget
```json
{
  "type": "widget",
  "widget_type": "binary_simulator",
  "description": "Interactive binary to decimal converter"
}
```

#### Quiz
```json
{
  "type": "quiz",
  "questions": [
    {
      "id": "q1",
      "question": "Is `0110103` a binary number?",
      "type": "multiple_choice",
      "options": [
        {
          "id": "a",
          "text": "No",
          "correct": true
        },
        {
          "id": "b",
          "text": "Yes",
          "correct": false
        }
      ],
      "explanation": "Binary numbers can only contain digits 0 and 1."
    }
  ]
}
```

## Implementation

### Models
- `IbJsonPageData`: Main page data model
- `IbJsonContent`: Content container
- `IbJsonSection`: Individual content section
- `IbJsonChild`: Child page reference

### Renderer
- `JsonContentRenderer`: Renders JSON content sections
- Supports all content types: headings, paragraphs, sections, tables, examples, steps, widgets, quizzes

### API Service
- `IbApi.fetchJsonPageData()`: Fetches JSON page data
- Includes caching via DatabaseService
- Error handling with proper failure messages

### View Model
- `IbPageViewModel.fetchJsonPageData()`: Fetches and manages JSON page data
- Handles loading states and errors

### UI Components
- `NewIbChapterPage`: Updated to use JSON data for binary-representation pages
- `QuizWidget`: Updated to support JSON quiz format with explanations
- Fallback to markdown parser for non-JSON pages

## Usage

### For Binary Representation Pages
The app automatically uses JSON API for pages under `binary-representation`:
- `docs/binary-representation/index`
- `docs/binary-representation/binary-numbers`

### For Other Pages
Other pages show "Coming Soon" message as they are under development.

## Benefits

1. **Type Safety**: Strongly typed models prevent runtime errors
2. **Performance**: No markdown parsing overhead
3. **Maintainability**: Easier to add new content types
4. **Consistency**: Structured data ensures consistent rendering
5. **Extensibility**: Easy to add new section types
6. **Error Handling**: Better error messages and debugging

## Future Enhancements

1. Add more content types (videos, interactive elements)
2. Support for inline formatting (bold, italic, code)
3. Image support with lazy loading
4. Search functionality
5. Offline support with better caching
