# Cache third-party responses to disk when testing or debugging

Any time you exercise a third-party service (an API, a scraper target, a remote dataset) from a test or an ad-hoc debugging/diagnostic script, persist each response to disk and read from that cache on re-run. Iterating on the code must not re-hit the service.

**Why:** Debugging is iterative — you'll run the script ten times tweaking output. Re-fetching every run hammers someone else's servers (rude, rate-limit-tripping, sometimes against their terms), makes runs slow, and makes results non-reproducible if the upstream changes between runs. Production code usually already caches (Redis, a CDN, a DB), but a throwaway script bypasses all of that, so it's the script that does the hammering.

**How to apply:**
- **Unit tests: never hit the network.** Bake a real captured response in as a fixture and mock the call. (This is the "fixture from real API data" rule — caching to disk is its debugging-script counterpart.)
- **Debugging/diagnostic scripts: write a tiny disk cache.** Key each request (URL, id, query) to a file under a temp dir; on run, return the file if present, else fetch once and write it. A 10-line `diskCached(key, () => fetch(...))` wrapper is enough — no cache library needed.
  ```ts
  async function diskCached<T>(key: string, produce: () => Promise<T>): Promise<T> {
    const path = `/tmp/<tool>-cache/${key.replace(/[^a-zA-Z0-9._-]/g, "_")}.json`;
    if (existsSync(path)) return JSON.parse(await readFile(path, "utf8"));
    const value = await produce();
    await writeFile(path, JSON.stringify(value));
    return value;
  }
  ```
- Cache the catalog/index call *and* every per-item detail call — the per-item calls are usually where the volume is (hundreds of them).
- State the cache location and how to bust it (e.g. "delete `/tmp/<tool>-cache` to force a refetch") so a stale cache is never a mystery.
- The first run still fetches (and populates the cache); every run after is offline. If you change what you request, change the key so you don't read a stale shape.
