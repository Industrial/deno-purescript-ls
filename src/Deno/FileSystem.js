export const chmod$prime = Deno.chmod

export const chmodSync$prime = (path) => {
  return (mode) => {
    return Deno.chmodSync(path, mode)
  }
}

export const chown$prime = (path) => {
  return (uid) => {
    return async (gid) => {
      return await Deno.chown(path, uid, gid)
    }
  }
}

export const chownSync$prime = (path) => {
  return (uid) => {
    return (gid) => {
      return Deno.chownSync(path, uid, gid)
    }
  }
}

export const readDir$prime = async (path) => {
  const entries = Deno.readDir(path)

  const output = []

  for await (const entry of entries) {
    output.push(entry)
  }

  return output
}

export const stat$prime = async (path) => {
  return Deno.stat(path)
}
