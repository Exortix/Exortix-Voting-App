import moustachu
import json
import strutils


const GeneralTemplate = dedent readFile("templates/general_template.html");

proc showPage*(pageFile: string, content: JsonNode, msgList: seq[string]): string =
    content["msgList"] = newJArray()
    for msg in msgList:
        content["msgList"].add(newJString(msg))
    let core = readFile("pages/$1.html".format(pageFile))
    let coreRendered = render(core, content)
    content["core_html"] = newJString(coreRendered)
    result = render(GeneralTemplate, content)
    