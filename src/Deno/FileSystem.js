export const chmod$prime = Deno.chmod
export const chmodSync$prime = Deno.chmodSync
export const chown$prime = Deno.chown
export const chownSync$prime = Deno.chownSync

// TODO: Fix the bug where this can't be represented with $prime.
export const readDirInt = async (path) => {
  const entries = Deno.readDir(path)

  const output = []

  for await (const entry of entries) {
    output.push(entry)
  }

  return output
}

// TODO: Fix the bug where this can't be represented with $prime.
export const statString = Deno.stat
