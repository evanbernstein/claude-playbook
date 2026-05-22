# Redis

Conventions for projects using Redis as a cache.

## Cache key versioning

When you change the shape of a value stored in Redis (rename a field, add or remove a field, change a type, change semantics), bump the version suffix on every cache key that holds that value (e.g. `:v2` → `:v3`).

Without the bump, deployed instances on the new code read stale-shape payloads written by the previous version, until each key's TTL expires. The failure is silent and intermittent: you'll see the wrong shape for some requests and the right shape for others, depending on which key happened to be cached.

The version suffix lives in code as a constant per cache namespace. When you change the shape, the bump ships in the same diff as the shape change.
