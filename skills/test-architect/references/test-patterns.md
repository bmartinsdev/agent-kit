# Full-Stack Test Patterns Reference

Use these idiomatic patterns when writing Vitest (TypeScript/React) and Go (`testing` / `httptest`) unit and integration suites.

---

## 1. Vitest Pure Utility & Formatter Pattern (`*.test.ts`)

```typescript
import { describe, it, expect } from 'vitest';
import { formatBytes } from '@/app/utils/formatters';

describe('formatBytes', () => {
  it.each([
    [0, '0 B'],
    [1024, '1 KB'],
    [1048576, '1 MB'],
  ])('formats %i bytes as %s', (input, expected) => {
    expect(formatBytes(input)).toBe(expected);
  });
});
```

---

## 2. Vitest Component & Manifest Validation Pattern (`*.test.tsx` / `*.test.ts`)

```typescript
import fs from 'fs';
import path from 'path';
import { describe, it, expect } from 'vitest';

describe('Plugin Manifests Validation', () => {
  const pluginsDir = path.resolve(__dirname, '../plugins');
  const pluginFolders = fs
    .readdirSync(pluginsDir, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => d.name);

  it.each(pluginFolders)('plugin "%s" has a valid plugin.json manifest', (pluginId) => {
    const manifestPath = path.join(pluginsDir, pluginId, 'plugin.json');
    expect(fs.existsSync(manifestPath)).toBe(true);
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8')) as {
      id: string;
      name: string;
      version: string;
      type: string;
    };
    expect(manifest.id).toBe(pluginId);
    expect(['indexer', 'torrent_client', 'media_server', 'metadata', 'tunnel']).toContain(
      manifest.type,
    );
  });
});
```

---

## 3. Go HTTP Handler & Isolated SQLite Pattern (`*_test.go`)

```go
package main

import (
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"testing"

	"silo-daemon/db"
)

func setupIsolatedTestDB(t *testing.T) {
	t.Helper()
	tmpDB := filepath.Join(t.TempDir(), "test_silo.db")
	if err := db.InitDB(tmpDB); err != nil {
		t.Fatalf("failed to init isolated test db: %v", err)
	}
}

func TestHandleStatus(t *testing.T) {
	setupIsolatedTestDB(t)

	req := httptest.NewRequest(http.MethodGet, "/api/status", nil)
	rec := httptest.NewRecorder()

	handleStatus(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", rec.Code)
	}
}
```
