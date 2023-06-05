import { Table } from "https://deno.land/x/cliffy@v0.25.7/table/mod.ts"

export const cliffyTable = (padding, indent, border, input) => {
  return Table
    .from(input)
    .padding(padding)
    .indent(indent)
    .border(border)
    .toString()
}
