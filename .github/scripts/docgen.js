import fs from "node:fs"
import process from "node:process"

const varargs = process.argv

console.log("v", varargs);
const sourceDocFile = varargs[2]
const targetDir = varargs[3]

// Degage la lib lua 

console.log("Reading source doc file ", sourceDocFile)
const docFileContent = fs.readFileSync(sourceDocFile)
const parserDocFileContent = JSON.parse(docFileContent);
const startLuaLibIndex = parserDocFileContent.findIndex((element) => element.name === "_G")
console.log("Starting index of lua lib", startLuaLibIndex)
const resultingArr = parserDocFileContent.splice(0, startLuaLibIndex)
// console.log("Resulting array ", JSON.stringify(resultingArr, null, '  '));


// Formate la documentation en Markdown
const arryWithStrings = resultingArr.map((entity) => ({
    ...entity,
    stringResult: formatToMarkdown(entity)
}));

// Groupe par classe
const grouppedByClass = Object.groupBy(arryWithStrings, (element) => {
    const [maybeClass, maybeRest] = element.name.split(".", 2)
    console.log("Maybe rest", maybeClass)
    if (maybeClass && maybeRest)
        return maybeClass
    else
        return "global"
});

const kv = Object.entries(grouppedByClass)

kv.map(([k, v]) => {
    const resultMarkdownString = v.map(e => e.stringResult).join('\n');
    fs.writeFileSync(`${targetDir}/${k.toLowerCase()}.md`, resultMarkdownString);
});


function formatToMarkdown(inputElement) {
    const elementType = inputElement.defines[0]?.view;
    console.log("element type ", elementType)
    if (elementType === "function")
        return formatFunction(inputElement.defines[0])

}

function formatFunction(inputFunctionElement) {
    return `
## ${inputFunctionElement.name}
${inputFunctionElement.rawdesc}

\`\`\`lua
${inputFunctionElement.extends.view}
\`\`\`

${formatReturn(inputFunctionElement.extends.returns?.[0])}

**Parameters**
${formatParameterTable(inputFunctionElement.extends.args)}



`
}

function formatParameterTable(inputParameterTable) {
    const header = 
        `| Name | Type | Description |
| ---- | ---- | ----------- | \n`

    const paramsPart = inputParameterTable
        .filter((p) => p.name !== "self")
        .map((param) => `| ${param.name} | ${param.view} | ${param.rawdesc ?? ''} |`).join('\n');
    return paramsPart.length === 0 ? '' : `${header}${paramsPart}`
}

function formatReturn(inputReturnTable) {
    if (!inputReturnTable) {
        return ''
    }
    return `
**Returns**
\`${inputReturnTable.view}\` ${inputReturnTable.rawdesc}
`
}

