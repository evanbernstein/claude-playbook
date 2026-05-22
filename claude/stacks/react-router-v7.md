# React Router v7

Conventions for projects using React Router v7.

## Don't let server-only modules leak into client bundles

If a route component value-imports from a helper that itself imports `~/server/*`, database clients, or any server-only module, the build silently includes that server code in the client bundle. Client navigation breaks at runtime with no build-time warning.

The route component may only `import type` from such helpers; never value imports. Push runtime values through the loader instead, and consume them via `useLoaderData`.

```ts
import type { ServerHelper } from '~/lib/server-helper'  // OK: types are stripped at build time
import { someClientHelper } from '~/lib/client-helper'   // OK: fully client-safe

// The loader runs server-side; the result is serialized and arrives in the component.
export async function loader() {
  const { someServerHelper } = await import('~/lib/server-helper')
  return { value: someServerHelper() }
}

export default function Route() {
  const { value } = useLoaderData<typeof loader>()
  return <div>{value}</div>
}
```

## Enforce this with a test

This rule is mechanical enough to enforce with an automated test: walk every route `.tsx` file with an AST parser, find value-imports from server-only modules, and assert those identifiers are only referenced inside server-only export bodies (`loader`, `action`, `clientLoader`, `clientAction`, `headers`). Any other reference would pull the helper into the client bundle.

A working example using TypeScript + vitest lives in [server-import-leak.test.ts](https://github.com/biscuits-internet-project/bip-turbo/blob/main/apps/web/app/lib/server-import-leak.test.ts) (if that link doesn't work, try this [permalink](https://github.com/biscuits-internet-project/bip-turbo/blob/d3a79d65b3fbc85bf96c81d7952b255067ab4b64/apps/web/app/lib/server-import-leak.test.ts)). It uses `fast-glob` to find routes, the TypeScript compiler API to parse imports and locate server-only export spans, and reports any leak as a test failure.

If you're working in a React Router v7 project that doesn't have an equivalent test, propose adding one; this trap is exactly the kind of thing that recurs and is much cheaper to catch with a test than with code review.
